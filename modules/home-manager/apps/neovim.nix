{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    extraLuaConfig = ''
      -- Set leader key
      vim.g.mapleader = " "
      
      -- Basic settings
      vim.opt.number = true
      vim.opt.relativenumber = true
      vim.opt.expandtab = true
      vim.opt.shiftwidth = 2
      vim.opt.tabstop = 2
      vim.opt.smartindent = true
      vim.opt.ignorecase = true
      vim.opt.smartcase = true
      vim.opt.termguicolors = true
      
      -- Enable syntax highlighting
      vim.cmd('syntax enable')
      
      -- Setup completion
      require('mini.completion').setup({
        delay = { completion = 100, info = 100, signature = 50 },
        window = {
          info = { height = 25, width = 80, border = 'none' },
          signature = { height = 25, width = 80, border = 'none' },
        },
      })
      
      -- Setup fzf-lua
      require('fzf-lua').setup({
        winopts = {
          height = 0.85,
          width = 0.80,
          row = 0.35,
          col = 0.50,
        }
      })
      
      -- Ctrl+P for file search
      vim.keymap.set('n', '<C-p>', '<cmd>FzfLua files<cr>', { desc = 'Find files' })
      vim.keymap.set('n', '<leader>fg', '<cmd>FzfLua live_grep<cr>', { desc = 'Live grep' })
      vim.keymap.set('n', '<leader>fb', '<cmd>FzfLua buffers<cr>', { desc = 'Find buffers' })
      
      -- LSP setup
      local lspconfig = require('lspconfig')
      
      -- Enable LSP servers
      lspconfig.bashls.setup{
        filetypes = { "sh", "bash", "zsh" }  -- bashls can handle zsh too
      }
      lspconfig.ruby_lsp.setup{}
      lspconfig.pyright.setup{}
      lspconfig.lua_ls.setup{
        settings = {
          Lua = {
            runtime = { version = 'LuaJIT' },
            diagnostics = { globals = {'vim'} },
            workspace = {
              library = vim.api.nvim_get_runtime_file("", true),
              checkThirdParty = false,
            },
            telemetry = { enable = false },
          },
        },
      }
      lspconfig.nil_ls.setup{}
      
      -- LSP keybindings
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = 'Go to definition' })
      vim.keymap.set('n', 'K', vim.lsp.buf.hover, { desc = 'Hover documentation' })
      vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { desc = 'Code actions' })
      vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { desc = 'Rename' })
      vim.keymap.set('n', 'gr', vim.lsp.buf.references, { desc = 'References' })
    '';

    plugins = with pkgs.vimPlugins; [
      mini-completion
      fzf-lua
      nvim-lspconfig
    ];
  };

  home.packages = with pkgs; [
    # LSP servers
    bash-language-server
    ruby-lsp
    pyright
    lua-language-server
    nil  # Nix LSP
    
    # Required for fzf-lua
    fzf
    ripgrep
    fd
  ];
}
