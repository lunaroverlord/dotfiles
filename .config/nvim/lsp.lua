-- Configure pyright
vim.lsp.config.pyright = {
  cmd = { 'pyright-langserver', '--stdio' },  -- Note the correct command[3]
  filetypes = { "python", "py" },
  root_markers = { 
    "pyproject.toml", 
    "setup.py", 
    "setup.cfg", 
    "requirements.txt", 
    "Pipfile", 
    "pyrightconfig.json",
    ".git"
  },
  settings = {
    python = {
      analysis = {
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
      },
    },
  },
}

-- Set up key mappings when LSP attaches to a buffer
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    local bufnr = args.buf
    
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'
    
    -- Buffer local mappings
    local opts = { buffer = bufnr }
    
    
    -- Enable auto-completion if the client supports it
    if client.supports_method('textDocument/completion') then
      vim.lsp.completion.enable(true, client.id, bufnr, { autotrigger = false })
      vim.keymap.set('i', '<c-n>', function() vim.lsp.completion.get() end)
    end

    vim.diagnostic.config({
      virtual_lines = { current_line = true },
    })
  end,
})

-- Enable the configured LSP
vim.lsp.enable('pyright')
vim.lsp.completion.enable()

