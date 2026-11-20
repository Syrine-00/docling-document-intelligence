# Member 3 - Chunking and grounded Q&A

1. Chunk the document with Docling's `HybridChunker` (`from docling.chunking import HybridChunker`),
   keeping page, table id and validation status for each chunk.
2. Retrieve relevant chunks for a question.
3. Answer ONLY from tables whose verdict is `passed: true`, and cite page and table.
   If validation failed, refuse or warn.

Not tested by Member 1: how to reload a `.docling.json` file as a `DoclingDocument`. Check the official docs first:
https://docling-project.github.io/docling/
