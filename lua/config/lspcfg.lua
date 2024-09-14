local nvim_lsp = require('lspconfig')

-- Will only activate deno if there is a deno.jsonc in there
nvim_lsp.denols.setup {
  on_attach = on_attach,
  root_dir = nvim_lsp.util.root_pattern("deno.json", "deno.jsonc"),
}

-- this is probs for linting the typescript stuff. Maybe remove this if it causes issues
nvim_lsp.tsserver.setup {
  on_attach = on_attach,
  root_dir = nvim_lsp.util.root_pattern("package.json"),
  single_file_support = false
}
