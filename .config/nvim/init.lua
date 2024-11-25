-- Bootstrap lazy.nvim
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

-- Set leader key before lazy
vim.g.mapleader = " "

-- Configure plugins
require("lazy").setup({
    -- Theme
    { "morhetz/gruvbox" },

    -- Essential plugins
    { "tpope/vim-sensible" },
    { "nvim-lua/plenary.nvim" },
    { "HakonHarnes/img-clip.nvim" },
    { "rhysd/vim-healthcheck" },

    -- Telescope and related plugins
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.8",
        dependencies = {
            { "nvim-telescope/telescope-fzf-native.nvim", build = "make" }
        },
    },

    -- LSP and completion
    { "neovim/nvim-lspconfig" },
    { "echasnovski/mini.nvim" },
    { "HiPhish/rainbow-delimiters.nvim" },

    -- Treesitter
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
    },

    -- File explorer
    {
        "preservim/nerdtree",
        dependencies = {
            "Xuyuanp/nerdtree-git-plugin",
            "ryanoasis/vim-devicons",
            "tiagofumo/vim-nerdtree-syntax-highlight",
            "PhilRunninger/nerdtree-visual-selection",
        },
    },

    -- Obsidian
    {
        "epwalsh/obsidian.nvim",
        version = "*",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope.nvim",
            "godlygeek/tabular",
            "preservim/vim-markdown",
        },
        config = function()
            require("obsidian").setup({
                workspaces = {
                    {
                        name = "ObsidianNotes",
                        path = "~/ObsidianNotes",
                    },
                },
                new_notes_location = "current_dir",
                templates = {
                    folder = "Obsidian/Templates",
                    date_format = "%Y-%m-%d-%a",
                    time_format = "%H:%M",
                },
                daily_notes = {
                    folder = "Daily/Planning",
                    date_format = "%Y-%m-%d",
                    alias_format = "%B %-d, %Y",
                    default_tags = { "daily-notes" },
                    template = 'Obsidian/Templates/DailyNoteTemplate.md'
                },
            })
        end,
    },

    -- Commander
    {
        "FeiyouG/commander.nvim",
        dependencies = { "nvim-telescope/telescope.nvim" }
    },

    -- Wilder
    {
        "gelguy/wilder.nvim",
        config = function()
            local wilder = require('wilder')
            wilder.setup({ modes = { ':', '/', '?' } })
        end,
    },

    -- Formatting
    { "jose-elias-alvarez/null-ls.nvim" },
    { "MunifTanjim/prettier.nvim" },
    { "m4xshen/autoclose.nvim" },

    -- Copilot
    {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        event = "InsertEnter",
        config = function()
            require("copilot").setup({
                suggestion = {
                    enabled = true,
                    auto_trigger = true,
                    debounce = 75,
                    keymap = {
                        accept = "<Tab>",
                        accept_word = false,
                        accept_line = false,
                        next = "<M-]>",
                        prev = "<M-[>",
                        dismiss = "<C-]>",
                    },
                },
                panel = { enabled = false },
            })
        end,
    },

    -- Which-key
    {
        "folke/which-key.nvim",
        config = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
            require("which-key").setup {}
        end,
    },

    -- Completion
    { "hrsh7th/nvim-cmp" },
    { "hrsh7th/cmp-nvim-lsp" },
    { "hrsh7th/cmp-buffer" },
    { "hrsh7th/cmp-path" },
    { "hrsh7th/cmp-cmdline" },
    { "L3MON4D3/LuaSnip" },
    { "saadparwaiz1/cmp_luasnip" },

    -- Dart and Flutter
    { "dart-lang/dart-vim-plugin" },
    {
        "akinsho/flutter-tools.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "stevearc/dressing.nvim",
        },
    },
    { "mfussenegger/nvim-dap" },
    { "nvim-telescope/telescope-dap.nvim" },

    -- Icons
    { "nvim-tree/nvim-web-devicons" },
})

-- Set options
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.conceallevel = 1

-- Window navigation
vim.api.nvim_set_keymap('n', '<C-k>', ':wincmd k<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-j>', ':wincmd j<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-h>', ':wincmd h<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-l>', ':wincmd l<CR>', { noremap = true, silent = true })

-- Telescope bindings
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

-- Auto-save for Markdown notes with debounce
local timer = vim.loop.new_timer()
local function debounced_save()
    if timer:is_active() then
        timer:stop()
    end
    timer:start(3000, 0, vim.schedule_wrap(function()
        local filetype = vim.bo.filetype
        if filetype == "markdown" then
            vim.cmd("silent! write")
        end
    end))
end

vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
    pattern = { "*.md" },
    callback = debounced_save
})

-- Obsidian keybindings
vim.api.nvim_set_keymap('n', '<leader>ot', ':ObsidianTemplate<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>od', ':ObsidianToday<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>on', ':ObsidianNew<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>oq', ':ObsidianQuickSwitch<CR>', { noremap = true, silent = true })

-- Theme settings
vim.o.background = "dark"
vim.g.gruvbox_contrast_dark = "medium"
vim.g.gruvbox_invert_selection = 0
vim.cmd.colorscheme("gruvbox")

-- GUI font
vim.o.guifont = "CommitMono Nerd Font Mono Italic:h14"

-- NERDTree settings
vim.g.NERDTreeShowHidden = 1
vim.g.NERDTreeMinimalUI = 1
vim.g.NERDTreeIgnore = {}
vim.g.NERDTreeStatusline = ''

-- NERDTree autocommands
vim.cmd([[
  autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
]])

-- NERDTree keybindings
vim.api.nvim_set_keymap('n', '<leader>n', ':NERDTreeToggle<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>f', ':NERDTreeFind<CR>', { noremap = true, silent = true })

-- Commander setup
require("commander").setup()

-- Telescope setup
require('telescope').setup {
    extensions = {
        fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
        }
    }
}
pcall(require('telescope').load_extension, 'fzf')

-- Autoclose setup
require("autoclose").setup()

-- Rainbow delimiters setup
local rainbow_delimiters = require('rainbow-delimiters')
vim.g.rainbow_delimiters = {
    strategy = {
        [''] = rainbow_delimiters.strategy.global,
        vim = rainbow_delimiters.strategy.global,
    },
    query = {
        [''] = 'rainbow-delimiters',
        lua = 'rainbow-blocks',
        javascript = 'rainbow-delimiters',
    },
    highlight = {
        'RainbowDelimiterRed',
        'RainbowDelimiterYellow',
        'RainbowDelimiterBlue',
        'RainbowDelimiterOrange',
        'RainbowDelimiterGreen',
        'RainbowDelimiterViolet',
        'RainbowDelimiterCyan',
    },
    blacklist = {},
}

-- Completion setup
local cmp = require('cmp')
cmp.setup({
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
    }),
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
    }, {
        { name = 'buffer' },
    })
})

-- Set up specific filetype completion
cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
        { name = 'git' },
    }, {
        { name = 'buffer' },
    })
})

-- Command line completion
cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = 'buffer' }
    }
})

cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources(
        { { name = 'path' } },
        { { name = 'cmdline' } }
    )
})

-- LuaSnip setup
local luasnip = require('luasnip')
luasnip.config.set_config {
    enable_jsregexp = true,
}

-- LSP setup
local capabilities = require('cmp_nvim_lsp').default_capabilities()
local nvim_lsp = require('lspconfig')

-- LSP servers configuration
local servers = {
    'pyright',
    'ts_ls',
    'rust_analyzer',
    'clangd',
    'gopls',
    'sourcekit',
    'bashls',
    'dartls',
}

for _, lsp in ipairs(servers) do
    if lsp == 'dartls' then
        nvim_lsp[lsp].setup {
            capabilities = capabilities,
            settings = {
                dart = {
                    sdkPath = os.getenv("HOME") .. "/flutter/bin/cache/dart-sdk",
                },
            },
        }
    else
        nvim_lsp[lsp].setup {
            capabilities = capabilities,
        }
    end
end

-- LSP keybindings
local opts = { noremap = true, silent = true }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

-- LSP attach configuration
vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(ev)
        vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

        local bufopts = { noremap = true, silent = true, buffer = ev.buf }
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
        vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
        vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
        vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
        vim.keymap.set('n', '<space>wl', function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, bufopts)
    end,
})

-- Null-ls setup
local null_ls = require("null-ls")
local group = vim.api.nvim_create_augroup("lsp_format_on_save", { clear = false })
local event = "BufWritePre"
local async = event == "BufWritePost"

null_ls.setup({
    sources = {
        null_ls.builtins.formatting.prettierd.with({
            filetypes = {
                "javascript",
                "typescript",
                "javascriptreact",
                "typescriptreact",
                "css",
                "scss",
                "html",
                "json",
                "yaml",
                "markdown",
            },
        }),
        null_ls.builtins.formatting.dart_format,
    },
    on_attach = function(client, bufnr)
        if client.supports_method("textDocument/formatting") then
            vim.keymap.set("n", "<Leader>f", function()
                vim.lsp.buf.format { bufnr = vim.api.nvim_get_current_buf() }
            end, { buffer = bufnr, desc = "[lsp] format" })

            vim.api.nvim_clear_autocmds { buffer = bufnr, group = group }
            vim.api.nvim_create_autocmd(event, {
                buffer = bufnr,
                group = group,
                callback = function()
                    vim.lsp.buf.format { bufnr = bufnr, async = async }
                end,
                desc = "[lsp] format on save",
            })
        end

        if client.supports_method("textDocument/rangeFormatting") then
            vim.keymap.set("x", "<Leader>f", function()
                vim.lsp.buf.format { bufnr = vim.api.nvim_get_current_buf() }
            end, { buffer = bufnr, desc = "[lsp] format" })
        end
    end,
})

-- Prettier setup
local prettier = require("prettier")
prettier.setup({
    bin = 'prettierd',
    filetypes = {
        "css",
        "graphql",
        "html",
        "javascript",
        "javascriptreact",
        "json",
        "less",
        "markdown",
        "scss",
        "typescript",
        "typescriptreact",
        "yaml",
    },
    ["null-ls"] = {
        condition = function()
            return prettier.config_exists {
                check_package_json = true,
            }
        end,
        runtime_condition = function(params)
            return true
        end,
        timeout = 5000,
    },
    cli_options = {
        arrow_parens = "always",
        bracket_spacing = true,
        bracket_same_line = false,
        embedded_language_formatting = "auto",
        end_of_line = "lf",
        html_whitespace_sensitivity = "css",
        jsx_single_quote = false,
        print_width = 80,
        quote_props = "as-needed",
        semi = true,
        single_attribute_per_line = false,
        single_quote = false,
        tab_width = 2,
        trailing_comma = "es5",
        use_tabs = false,
        vue_indent_script_and_style = false,
    },
})

-- Prettier keybindings
vim.api.nvim_set_keymap('n', '<Leader>p', ':Prettier<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('x', '<Leader>p', ':Prettier<CR>', { noremap = true, silent = true })

-- Additional NERDTree keybindings
vim.api.nvim_set_keymap('n', '<leader>e', ':NERDTreeFocus<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>tf', ':NERDTreeFind<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>tc', ':NERDTreeClose<CR>', { noremap = true, silent = true })

-- NERDTree autocommands
vim.cmd([[
  autocmd StdinReadPre * let s:std_in=1
  autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists('s:std_in') |
      \ execute 'NERDTree' argv()[0] | wincmd p | enew | execute 'cd '.argv()[0] | endif

  autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

  autocmd BufEnter * if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

  autocmd BufWinEnter * if &buftype != 'quickfix' && getcmdwintype() == '' | silent NERDTreeMirror | endif
]])

-- NERDTree Git plugin settings
vim.g.NERDTreeGitStatusUseNerdFonts = 1
vim.g.NERDTreeGitStatusShowIgnored = 1
vim.g.NERDTreeGitStatusUntrackedFilesMode = 'all'
vim.g.NERDTreeGitStatusShowClean = 1
vim.g.NERDTreeGitStatusConcealBrackets = 1

-- NERDTree appearance
vim.g.NERDTreeDirArrowExpandable = '▸'
vim.g.NERDTreeDirArrowCollapsible = '▾'

-- NERDTree Git status indicators
vim.g.NERDTreeGitStatusIndicatorMapCustom = {
    Modified  = "✹",
    Staged    = "✚",
    Untracked = "✭",
    Renamed   = "➜",
    Unmerged  = "═",
    Deleted   = "✖",
    Dirty     = "✗",
    Ignored   = "☒",
    Clean     = "✔︎",
    Unknown   = "?",
}

-- Flutter Tools setup
require('flutter-tools').setup {
    ui = {
        border = "rounded",
    },
    decorations = {
        statusline = {
            app_version = true,
            device = true,
        }
    },
    widget_guides = {
        enabled = true,
    },
    closing_tags = {
        highlight = "Comment",
        prefix = "//",
        enabled = true,
    },
    dev_log = {
        enabled = true,
        notify_errors = true,
    },
    lsp = {
        color = {
            enabled = true,
            background = true,
            virtual_text = true,
        },
        settings = {
            showTodos = true,
            completeFunctionCalls = true,
        },
        on_attach = function(client, bufnr)
            -- Your custom on_attach function
        end,
    },
}

-- DAP setup
local dap = require('dap')

-- Dart DAP configuration
dap.adapters.dart = {
    type = 'executable',
    command = 'dart',
    args = { 'debug_adapter' },
}

-- Flutter DAP configuration
dap.adapters.flutter = {
    type = 'executable',
    command = 'flutter',
    args = { 'debug_adapter' },
}

-- DAP configurations for Dart
dap.configurations.dart = {
    {
        type = "dart",
        request = "launch",
        name = "Launch Dart Program",
        dartSdkPath = os.getenv("HOME") .. "/flutter/bin/cache/dart-sdk/",
        flutterSdkPath = os.getenv("HOME") .. "/flutter",
        program = "${file}",
        cwd = "${workspaceFolder}",
        args = {},
    },
}

-- DAP configurations for Flutter
dap.configurations.flutter = {
    {
        type = "flutter",
        request = "launch",
        name = "Launch Flutter App",
        dartSdkPath = os.getenv("HOME") .. "/flutter/bin/cache/dart-sdk/",
        flutterSdkPath = os.getenv("HOME") .. "/flutter",
        program = "${workspaceFolder}/lib/main.dart",
        cwd = "${workspaceFolder}",
        args = {},
    },
}

-- DAP signs and keymaps
vim.fn.sign_define('DapBreakpoint', { text = '🛑', texthl = '', linehl = '', numhl = '' })
vim.api.nvim_set_keymap('n', '<F5>', ':DapContinue<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<F10>', ':DapStepOver<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<F11>', ':DapStepInto<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<F12>', ':DapStepOut<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>b', ':DapToggleBreakpoint<CR>', { noremap = true, silent = true })
