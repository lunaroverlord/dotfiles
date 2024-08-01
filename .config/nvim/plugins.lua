if not vim.fn then
  return
end

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)


require("lazy").setup({
    {
        "benlubas/molten-nvim",
        version = "^1.0.0", -- use version <2.0.0 to avoid breaking changes
        build = ":UpdateRemotePlugins",
        init = function()
            vim.g.molten_output_win_max_height = 200
            vim.g.molten_image_provider = "image.nvim"
            vim.g.molten_auto_open_html_in_browser = 0
        end,
    };
    {
        "3rd/image.nvim",
        build = ":UpdateRemotePlugins",
        init = function()
            require("image").setup({
              backend = "kitty",
              max_width = nil,
              max_height = nil,
              max_width_window_percentage = 100,
              max_height_window_percentage = 100,
            })
        end,
    };
    {
        "CopilotC-Nvim/CopilotChat.nvim",
        build = ":UpdateRemotePlugins",
        branch = "canary",
        init = function()
            require("CopilotChat").setup({
              debug = true,
            })
        end,
    };
    {
        'github/copilot.vim',
        branch = 'release',
        build = ':UpdateRemotePlugins',
    };
    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
    };
    -- init.lua:
    {
        'nvim-telescope/telescope.nvim', tag = '0.1.8',
        dependencies = { 'nvim-lua/plenary.nvim' }
    };
    {
      "epwalsh/obsidian.nvim",
      version = "*",  -- recommended, use latest release instead of latest commit
      lazy = true,
      ft = "markdown",
      -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
      -- event = {
      --   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
      --   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/**.md"
      --   "BufReadPre path/to/my-vault/**.md",
      --   "BufNewFile path/to/my-vault/**.md",
      -- },
      dependencies = { "nvim-lua/plenary.nvim", },
      opts = {
        workspaces = {
          {
            name = "personal",
            path = "~/Documents/Obsidian Vault",
          },
          {
            name = "maxtor",
            path = "~/maxtor/mandragora/dox",
          },
        },
        picker = {
            -- Set your preferred picker. Can be one of 'telescope.nvim', 'fzf-lua', or 'mini.pick'.
            name = "telescope.nvim",
        },
      },
    };
    {
        "jpalardy/vim-slime",
        init = function()
            vim.g.slime_python_ipython = 1
            vim.g.slime_target = "x11"
            vim.g.slime_cell_delimiter = "#%%"
        end,
    };
    {
         "GCBallesteros/jupytext.nvim",
         config = true,
         -- Plug 'GCBallesteros/NotebookNavigator.nvim', { 'branch': 'main', 'do': ':UpdateRemotePlugins' } 
    };
    {
        'nvim-lua/plenary.nvim'
    };
    {
        'neoclide/coc.nvim',
        branch = 'release',
    };
    {
        'junegunn/fzf.vim',
    };
    {
        'junegunn/fzf',
    };
    {
        'justinmk/vim-sneak',
    };
    {
        'mg979/vim-visual-multi',
    };
    {
        'mvanderkamp/vim-pudb-and-jam',
    };
    {
        'lewis6991/gitsigns.nvim',
        config = function()
            require('gitsigns').setup()
        end
    };
    {
        'bling/vim-airline',
        init = function()
            vim.g["airline#extensions#tabline#enabled"] = 1
            vim.g.airline_powerline_fonts = 1
            vim.g.airline_theme='afterglow'
        end,
    };
    {
        "danilo-augusto/vim-afterglow",
        --"let g:afterglow_italic_comments=1
    };
})

--Plugin 'tpope/vim-fugitive'
--Plugin 'justinmk/vim-gtfo' 
--Plugin 'trapd00r/neverland-vim-theme'
--Plugin 'tpope/vim-sleuth'
--Plugin 'scrooloose/nerdtree'
--Plugin 'tidalcycles/vim-tidal'
--Bundle 'yonchu/accelerated-smooth-scroll'
