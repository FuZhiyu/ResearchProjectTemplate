# Mistral PDF to Markdown - Reference Guide

Advanced usage, API details, and troubleshooting for the Mistral OCR PDF converter.

## API Details

### Mistral OCR API

The conversion uses Mistral's OCR API (`mistral-ocr-latest` model):

**Endpoint:** `https://api.mistral.ai/v1/ocr`

**Authentication:** Bearer token via `MISTRAL_API_KEY`

**Supported Formats:**
- PDF, PPTX, DOCX
- PNG, JPEG, AVIF images

### Response Structure

```python
OCRResponse
├── pages: List[OCRPageObject]
│   ├── index: int
│   ├── markdown: str
│   ├── images: List[ImageObject]
│   │   ├── id: str (e.g., "img-0.jpeg")
│   │   ├── top_left_x, top_left_y: float
│   │   ├── bottom_right_x, bottom_right_y: float
│   │   └── image_base64: str (when include_image_base64=True)
│   └── dimensions: OCRPageDimensions
│       ├── dpi: int
│       ├── height: int
│       └── width: int
├── model: str ("mistral-ocr-2505-completion")
├── usage_info: OCRUsageInfo
│   ├── pages_processed: int
│   └── doc_size_bytes: int
└── document_annotation: Optional[Any]
```

### Image Data Format

Images are returned in base64-encoded format:

```
data:image/jpeg;base64,/9j/4AAQSkZJRgABAQAAAQABAAD...
```

The script automatically:
1. Strips the data URI prefix (`data:image/jpeg;base64,`)
2. Decodes the base64 string
3. Saves as JPEG files

## Advanced Usage

### Programmatic Usage

```python
import sys
sys.path.append('.claude/skills/mistral-pdf-to-markdown/scripts')
from convert_pdf_to_markdown import (
    load_api_key,
    extract_pages,
    process_with_mistral,
    save_images
)

# Load API key
api_key = load_api_key()

# Extract pages
base64_pdf = extract_pages("input.pdf", page_selection="1-5")

# Process with Mistral
ocr_response = process_with_mistral(api_key, base64_pdf)

# Custom image handling
for page_idx, page in enumerate(ocr_response.pages):
    print(f"Page {page_idx}: {len(page.images)} images")
    for img in page.images:
        print(f"  Image position: ({img.top_left_x}, {img.top_left_y})")
```

### Batch Processing

```python
from pathlib import Path
import subprocess

# Process multiple PDFs
pdf_dir = Path("Data/papers")
output_dir = Path("Output/PDFConversions")

for pdf_file in pdf_dir.glob("*.pdf"):
    output_file = output_dir / f"{pdf_file.stem}.md"

    subprocess.run([
        "python",
        ".claude/skills/mistral-pdf-to-markdown/scripts/convert_pdf_to_markdown.py",
        str(pdf_file),
        str(output_file)
    ])
```

### Custom Output Location

The script always creates an `images/` folder in the same directory as the output markdown file:

```python
# Output structure is automatically created
output_path = Path("custom/location/document.md")
# → Images saved to: custom/location/images/img-*.jpeg
```

## Performance Considerations

### API Limits

- **Rate limits:** Check Mistral API documentation for current limits
- **File size:** Large PDFs (>50 pages) may timeout; use page selection
- **Processing time:** ~2-5 seconds per page depending on complexity

### Optimization Tips

1. **Extract specific pages** when you only need certain sections:
   ```bash
   --pages "10-20"  # Only process 10 pages instead of entire document
   ```

2. **Batch similar requests** to minimize API overhead

3. **Cache results** - Save converted markdown to avoid re-processing

## Troubleshooting

### Common Issues

#### 1. Empty or Missing Images

**Symptom:** Markdown shows image references but files not saved

**Cause:** Images may not have `image_base64` attribute

**Solution:** Verify `include_image_base64=True` in API call

```python
# Check API response
for page in ocr_response.pages:
    for img in page.images:
        if not hasattr(img, 'image_base64'):
            print(f"Warning: Image {img.id} missing base64 data")
```

#### 2. Incorrect Image Paths

**Symptom:** Markdown shows `![...](img-0.jpeg)` but images are in `images/`

**Cause:** Path replacement not applied

**Solution:** The script automatically fixes this with:
```python
markdown_content = markdown_content.replace('](img-', '](images/img-')
```

#### 3. API Authentication Errors

**Symptom:** `401 Unauthorized` error

**Causes:**
- Invalid API key
- Expired API key
- API key not loaded from `.env`

**Solutions:**
```bash
# Verify API key exists
cat Notes/.env | grep mistral_api_key

# Test API key manually
export MISTRAL_API_KEY="your-key-here"
python -c "from mistralai import Mistral; print(Mistral(api_key='$MISTRAL_API_KEY'))"
```

#### 4. Large File Processing

**Symptom:** Timeout or memory errors with large PDFs

**Solutions:**
- Extract pages in chunks: `--pages "1-10"`, then `--pages "11-20"`, etc.
- Reduce PDF size before processing (compress images)
- Process locally with `pdf` skill for non-OCR needs

### Debugging

Enable verbose output:

```python
# Add to script
import logging
logging.basicConfig(level=logging.DEBUG)
```

Check response details:

```python
print(f"Pages processed: {ocr_response.usage_info.pages_processed}")
print(f"Document size: {ocr_response.usage_info.doc_size_bytes} bytes")
print(f"Model: {ocr_response.model}")
```

## Comparison with Other Methods

| Feature | Mistral OCR | pypdf | pdfplumber |
|---------|-------------|-------|------------|
| Text extraction | ✓ Excellent | ✓ Good | ✓ Good |
| Scanned PDFs | ✓ Yes (OCR) | ✗ No | ✗ No |
| Image extraction | ✓ Automatic | ✗ No | ✗ No |
| Markdown output | ✓ Native | ✗ Manual | ✗ Manual |
| Cost | $ API calls | Free | Free |
| Speed | Moderate | Fast | Moderate |
| Formatting | ✓ Excellent | ~ Basic | ✓ Good |

**Use Mistral OCR when:**
- PDF contains scanned images requiring OCR
- Need Markdown output with formatting
- Want automatic image extraction
- Willing to pay for API usage

**Use local tools (`pdf` skill) when:**
- Processing many documents (cost savings)
- Simple text extraction sufficient
- No OCR required
- Need faster processing

## Example Workflows

### Extract Figures from Research Paper

```bash
# Step 1: Identify figure pages (manually or via table of contents)
# Assume figures are on pages 15, 18, 22, 25

# Step 2: Extract those pages
python scripts/convert_pdf_to_markdown.py \
  "paper.pdf" \
  "Output/PDFConversions/paper_figures.md" \
  --pages "15,18,22,25"

# Step 3: Images are now in Output/PDFConversions/images/
# Markdown contains captions and references
```

### Convert Book Chapter

```bash
# Chapter 3 is pages 45-78
python scripts/convert_pdf_to_markdown.py \
  "book.pdf" \
  "Output/PDFConversions/chapter3.md" \
  --pages "45-78"
```

### Process Scanned Document

```bash
# Scanned documents benefit most from OCR
python scripts/convert_pdf_to_markdown.py \
  "scanned_contract.pdf" \
  "Output/PDFConversions/contract.md"
```

## API Cost Estimation

Check Mistral's pricing page for current rates. As of 2025:

- Charged per page processed
- Image extraction may incur additional costs
- Larger pages (higher DPI) may cost more

**Example calculation:**
- 100-page document
- Only need pages 50-60 (10 pages)
- Use `--pages "50-60"` to process only 10 pages instead of 100

## Future Enhancements

Potential improvements to the script:

1. **Parallel processing** - Process multiple pages concurrently
2. **Resume capability** - Continue from last processed page after interruption
3. **Image format options** - Save as PNG instead of JPEG
4. **Markdown customization** - Custom heading levels, formatting styles
5. **OCR language detection** - Automatic language detection and processing
