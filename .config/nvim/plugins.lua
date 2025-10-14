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
        branch = "main",
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
        mappings = {},
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
            name = "fzf-lua",
        },
      },
    };
    {
      "yetone/avante.nvim",
      event = "VeryLazy",
      lazy = false,
      version = false, -- Set this to "*" to always pull the latest release version, or set it to false to update to the latest code changes.
      opts = {
        -- add any opts here
        -- for example
        providers = {
            openai = {
              endpoint = "https://api.openai.com/v1",
              model = "gpt-4o", -- your desired model (or use gpt-4o, etc.)
              timeout = 30000, -- timeout in milliseconds
              max_tokens = 4096,
            },
        }
      },
      -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
      build = "make",
      -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
      dependencies = {
        "stevearc/dressing.nvim",
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
        --- The below dependencies are optional,
        "echasnovski/mini.pick", -- for file_selector provider mini.pick
        "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
        "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
        "ibhagwan/fzf-lua", -- for file_selector provider fzf
        "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
        "zbirenbaum/copilot.lua", -- for providers='copilot'
        {
          -- support for image pasting
          "HakonHarnes/img-clip.nvim",
          event = "VeryLazy",
          opts = {
            -- recommended settings
            default = {
              embed_image_as_base64 = false,
              prompt_for_file_name = false,
              drag_and_drop = {
                insert_mode = true,
              },
              -- required for Windows users
              use_absolute_path = true,
            },
          },
        },
        {
          -- Make sure to set this up properly if you have lazy=true
          'MeanderingProgrammer/render-markdown.nvim',
          opts = {
            file_types = { "markdown", "Avante" },
          },
          ft = { "markdown", "Avante" },
        },
      },
    };
    {
        "jpalardy/vim-slime",
        init = function()
            -- vim.g.slime_python_ipython = 1
            vim.g.slime_target = "tmux"
        end,
    };
    {
      "mfussenegger/nvim-dap",
      dependencies = {
        "mfussenegger/nvim-dap-python",
        "rcarriga/nvim-dap-ui",
        "theHamsta/nvim-dap-virtual-text",
        "nvim-neotest/nvim-nio",
      },
      config = function()
        local dap = require('dap')
        require("dap").defaults.fallback.switchbuf = "usetab,uselast"

        local dap_python = require('dap-python')
        local dapui = require('dapui')
        require("dapui").setup({
            layouts = {
                {
                    elements = {
                        { id = "scopes", size = 0.25 },
                        { id = "breakpoints", size = 0.25 },
                        { id = "stacks", size = 0.25 },
                        { id = "watches", size = 0.25 },
                    },
                    size = 40,           -- width in columns
                    position = "right",  -- "left" or "right"
                },
                {
                    elements = {
                        { id = "repl", size = 0.5 },
                        { id = "console", size = 0.5 },
                    },
                    size = 10,           -- height in lines
                    position = "bottom", -- "bottom" or "top"
                },
            }
        })

        -- Basic keybindings
        vim.keymap.set("n", "<leader>b", require("dap").toggle_breakpoint)
        vim.keymap.set("n", "<leader>B", function()
          require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
        end, { desc = "Set Conditional Breakpoint" })
        vim.keymap.set('n', '<leader>x', function() 
            require("dap").disconnect({ terminateDebuggee = false })
            require('dap').repl.close()
            require("dap").close()
            require('dapui').close()
            require("nvim-dap-virtual-text").refresh()
        end)
        vim.keymap.set('n', '<leader>U', function() require('dapui').toggle() end)
        vim.keymap.set('n', '<leader>R', function() require("dap").repl.open() end)
        vim.keymap.set('n', '<leader>d', function() require('dap').continue() end)
        vim.keymap.set('n', '<leader>s', function() require('dap').step_over() end)
        vim.keymap.set('n', '<leader>S', function() require('dap').step_into() end)
        vim.keymap.set('n', '<C-s>', function() require('dap').step_out() end)
        vim.keymap.set('n', '<leader>e', function() require('dapui').eval() end)
        vim.keymap.set('n', '<leader>r', function() require('dapui').float_element("repl") end)

        -- Define highlight groups (optional, for custom colors)
        vim.api.nvim_set_hl(0, "DapBreakpoint", { fg = "#fa4848" })         -- Red
        vim.api.nvim_set_hl(0, "DapBreakpointCondition", { fg = "#f0a000" })-- Orange
        vim.api.nvim_set_hl(0, "DapLogPoint", { fg = "#00aaff" })           -- Blue
        vim.api.nvim_set_hl(0, "DapStopped", { fg = "#00ff00", bg = "#222222" }) -- Green with grey background

        -- Define the signs for nvim-dap
        vim.fn.sign_define('DapBreakpoint', { text = "●", texthl = "DapBreakpoint", linehl = "", numhl = "" })
        vim.fn.sign_define('DapBreakpointCondition', { text = "●", texthl = "DapBreakpointCondition", linehl = "", numhl = "" })
        vim.fn.sign_define('DapLogPoint', { text = "◆", texthl = "DapLogPoint", linehl = "", numhl = "" })
        vim.fn.sign_define('DapStopped', { text = "→", texthl = "DapStopped", linehl = "DapStopped", numhl = "" })
        vim.fn.sign_define('DapBreakpointRejected', { text = "", texthl = "DiagnosticError", linehl = "", numhl = "" })

        local mason_debugpy_path = vim.fn.stdpath('data') .. '/mason/packages/debugpy/venv/bin/python'
        dap_python.setup(mason_debugpy_path)

        dap_python.test_runner = 'pytest'

        dap.configurations.python = {
          {
            type = 'python',
            request = 'launch',
            name = "Launch File",
            program = "${file}",
            pythonPath = function()
              local venv = os.getenv('VIRTUAL_ENV')
              if venv then
                return venv .. '/bin/python'
              end
              return mason_debugpy_path
            end,
          },
          -- New config for Jupyter kernel attachment
          {
            type = 'python',
            request = 'attach',
            name = "Attach to Jupyter Kernel",
            port = 5678,
            justMyCode = true,
            subProcess = false,
            terminateDebugee = false,
            pathMappings = {
              {
                localRoot = vim.fn.getcwd(),
                remoteRoot = function()
                  return vim.fn.input(
                    'Jupyter kernel working dir > ',
                    vim.fn.getcwd(),  -- Default to current dir
                    'file'
                  )
                end,
              },
            },
          }
        }

        require("nvim-dap-virtual-text").setup {
          enabled = true,
          enabled_commands = true, 
          highlight_changed_variables = true,
          highlight_new_as_changed = true,
          show_stop_reason = true,
          commented = false,
          virt_text_pos = 'eol', -- or 'inline' if on Neovim 0.10+
        }
        -- Verify debugpy installation (optional)
        vim.schedule(function()
          local debugpy_check = vim.fn.system(mason_debugpy_path .. ' -c "import debugpy; print(debugpy.__version__)"')
          if vim.v.shell_error ~= 0 then
            vim.notify("Debugpy not found in Mason! Run :MasonInstall debugpy", vim.log.levels.ERROR)
          end
        end)
      end
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
    -- {
      --   'mvanderkamp/vim-pudb-and-jam',
    -- };
    -- maps ,swp and ,rwp which blocks s key
    --{
     --   'powerman/vim-plugin-AnsiEsc',
    --};
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
    {
        "rebelot/kanagawa.nvim",
    };
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        opts = {},
        init = function()
            vim.cmd[[colorscheme tokyonight-night]]
        end,
    };
    {
        "thesimonho/kanagawa-paper.nvim",
        lazy = false,
        priority = 1000,
        opts = {},
    };
    { "neovim/nvim-lspconfig", };
    { "mason-org/mason.nvim", opts = {} };
    {
      'mrcjkb/rustaceanvim',
      version = '^5', -- Recommended
      lazy = false, -- This plugin is already lazy
    };
    { 'echasnovski/mini.nvim', version = '*' };
    { 
        'echasnovski/mini.files',
        version = '*',
        config = function()
          require('mini.files').setup({
              windows = { preview = true, width_focus = 30, width_preview=30 },
              mappings = { close = "<esc>" },
          })
        end,
    };
    { "nvim-tree/nvim-web-devicons", opts = {} };
    {
      "nvim-neo-tree/neo-tree.nvim",
      branch = "v3.x",
      dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
        "MunifTanjim/nui.nvim",
        -- {"3rd/image.nvim", opts = {}}, -- Optional image support in preview window: See `# Preview Mode` for more information
      },
      lazy = false, -- neo-tree will lazily load itself
      ---@module "neo-tree"
      ---@type neotree.Config?
      opts = {
        -- fill any relevant options here
      },
    };
})

--Plugin 'tpope/vim-fugitive'
--Plugin 'justinmk/vim-gtfo' 
--Plugin 'trapd00r/neverland-vim-theme'
--Plugin 'tpope/vim-sleuth'
--Plugin 'scrooloose/nerdtree'
--Plugin 'tidalcycles/vim-tidal'
--Bundle 'yonchu/accelerated-smooth-scroll'
