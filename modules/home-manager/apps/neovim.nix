{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    plugins = with pkgs.vimPlugins; [
      {
        plugin = mini-nvim;
        type = "lua";
        config = ''
          require('mini.completion').setup({
            delay = { completion = 80, info = 100, signature = 50 },
            window = {
              info = { height = 25, width = 80, border = 'none' },
              signature = { height = 25, width = 80, border = 'none' },
            },
          })
        '';
      }

      {
        plugin = fzf-lua;
        type = "lua";
        config = ''
          require('fzf-lua').setup({
            winopts = {
              height = 0.85,
              width = 0.80,
              row = 0.35,
              col = 0.50,
            }
          })
        '';
      }

      {
        plugin = nvim-lspconfig;
        type = "lua";
        config = ''
          -- Load nvim-lspconfig server definitions into vim.lsp.config (no deprecated framework)
          pcall(require, 'lspconfig.configs')

          -- Configure servers by mutating vim.lsp.config, then enable them
          vim.lsp.config.bashls = vim.tbl_deep_extend('force', vim.lsp.config.bashls or {}, {
            filetypes = { 'sh', 'bash', 'zsh' },
          })

          vim.lsp.config.ruby_lsp = vim.tbl_deep_extend('force', vim.lsp.config.ruby_lsp or {}, {})
          vim.lsp.config.pyright = vim.tbl_deep_extend('force', vim.lsp.config.pyright or {}, {})

          vim.lsp.config.lua_ls = vim.tbl_deep_extend('force', vim.lsp.config.lua_ls or {}, {
            settings = {
              Lua = {
                runtime = { version = 'LuaJIT' },
                diagnostics = { globals = { 'vim' } },
                workspace = {
                  library = vim.api.nvim_get_runtime_file("", true),
                  checkThirdParty = false,
                },
                telemetry = { enable = false },
              },
            },
          })

          vim.lsp.config.nil_ls = vim.tbl_deep_extend('force', vim.lsp.config.nil_ls or {}, {})

          -- Enable all configured servers
          vim.lsp.enable({ 'bashls', 'ruby_lsp', 'pyright', 'lua_ls', 'nil_ls' })
        '';
      }

      # Removed explicit colorscheme so terminal background shows through
    ];

    extraLuaConfig = ''
      vim.g.mapleader = " "

      vim.opt.number = true
      vim.opt.relativenumber = true
      vim.opt.expandtab = true
      vim.opt.shiftwidth = 2
      vim.opt.tabstop = 2
      vim.opt.smartindent = true
      vim.opt.ignorecase = true
      vim.opt.smartcase = true
      vim.opt.termguicolors = true

      -- Clipboard integration with system clipboard
      vim.opt.clipboard = 'unnamedplus'

      vim.cmd('syntax enable')

      -- Inherit terminal background
      vim.api.nvim_create_autocmd('ColorScheme', {
        callback = function()
          vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
          vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'none' })
          vim.api.nvim_set_hl(0, 'SignColumn', { bg = 'none' })
        end,
      })

      -- Apply on startup too
      vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
      vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'none' })
      vim.api.nvim_set_hl(0, 'SignColumn', { bg = 'none' })

      vim.keymap.set('n', '<C-p>', '<cmd>FzfLua files<cr>', { desc = 'Find files' })
      vim.keymap.set('n', '<leader>fg', '<cmd>FzfLua live_grep<cr>', { desc = 'Live grep' })
      vim.keymap.set('n', '<leader>fb', '<cmd>FzfLua buffers<cr>', { desc = 'Find buffers' })

      -- LSP keybindings
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = 'Go to definition' })
      vim.keymap.set('n', 'K', vim.lsp.buf.hover, { desc = 'Hover documentation' })
      vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { desc = 'Code actions' })
      vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { desc = 'Rename' })
      vim.keymap.set('n', 'gr', vim.lsp.buf.references, { desc = 'References' })

      -- Clipboard keybindings (Ctrl+Shift+C/V and Super+C/V/X)
      vim.keymap.set('v', '<C-S-c>', '"+y', { desc = 'Copy to system clipboard' })
      vim.keymap.set('n', '<C-S-v>', '"+p', { desc = 'Paste from system clipboard' })
      vim.keymap.set('i', '<C-S-v>', '<C-r>+', { desc = 'Paste from system clipboard' })

      -- Super (Mod4) key clipboard shortcuts
      vim.keymap.set('v', '<D-c>', '"+y', { desc = 'Copy to system clipboard' })
      vim.keymap.set('v', '<D-x>', '"+d', { desc = 'Cut to system clipboard' })
      vim.keymap.set('n', '<D-v>', '"+p', { desc = 'Paste from system clipboard' })
      vim.keymap.set('i', '<D-v>', '<C-r>+', { desc = 'Paste from system clipboard' })
    '';
  };

  home.packages = with pkgs; [
    # LSP servers
    bash-language-server
    lua-language-server
    ruby-lsp
    pyright
    nil

    # Required for fzf-lua
    fzf
    ripgrep
    fd
  ];
}
