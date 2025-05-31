return {
  -- Add language parsers to Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      -- Add the languages to ensure_installed
      vim.list_extend(opts.ensure_installed, {
        "typescript",
        "tsx",
        "javascript",
        "java",
        "cpp",
        "c",
        "python",
        "rust",
        "go",
        "json",
        "gomod",
        "gosum",
        "gowork",
      })
    end,
  },

  -- Configure LSP servers
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- TypeScript
        tsserver = {
          settings = {
            typescript = {
              inlayHints = {
                includeInlayParameterNameHints = "all",
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              },
            },
            javascript = {
              inlayHints = {
                includeInlayParameterNameHints = "all",
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              },
            },
          },
        },

        -- Java
        jdtls = {}, -- We'll configure jdtls separately since it needs special handling

        -- C/C++
        clangd = {
          capabilities = {
            offsetEncoding = "utf-8",
          },
          cmd = {
            "clangd",
            "--background-index",
            "--clang-tidy",
            "--header-insertion=iwyu",
            "--completion-style=detailed",
            "--function-arg-placeholders",
          },
        },

        -- Python
        pyright = {
          settings = {
            python = {
              analysis = {
                typeCheckingMode = "basic",
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = "workspace",
              },
            },
          },
        },

        -- Rust
        rust_analyzer = {
          settings = {
            ["rust-analyzer"] = {
              checkOnSave = {
                command = "clippy",
              },
              imports = {
                granularity = {
                  group = "module",
                },
              },
              cargo = {
                buildScripts = {
                  enable = true,
                },
              },
              procMacro = {
                enable = true,
              },
            },
          },
        },

        -- Go
        gopls = {
          settings = {
            gopls = {
              gofumpt = true,
              codelenses = {
                gc_details = true,
                generate = true,
                regenerate_cgo = true,
                run_govulncheck = true,
                test = true,
                tidy = true,
                upgrade_dependency = true,
                vendor = true,
              },
              hints = {
                assignVariableTypes = true,
                compositeLiteralFields = true,
                compositeLiteralTypes = true,
                constantValues = true,
                functionTypeParameters = true,
                parameterNames = true,
                rangeVariableTypes = true,
              },
              analyses = {
                unusedparams = true,
                unusedvariable = true,
                nilness = true,
                shadow = true,
              },
              usePlaceholders = true,
              completeUnimported = true,
              staticcheck = true,
              directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
            },
          },
        },
      },
      setup = {
        -- Special setup for Java LSP
        jdtls = function()
          -- We'll use nvim-jdtls plugin to handle LSP setup
          return true -- Return true to disable default setup for jdtls
        },
      },
    },
  },

  -- Add Java specific support with nvim-jdtls
  {
    "mfussenegger/nvim-jdtls",
    ft = { "java" },
    config = function()
      local jdtls_ok, jdtls = pcall(require, "jdtls")
      if not jdtls_ok then
        return
      end

      -- Helper function to find root directory
      local root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }
      local root_dir = vim.fs.dirname(vim.fs.find(root_markers, { upward = true })[1] or "")

      local home = os.getenv("HOME")
      -- Use mason.nvim path for jdt.ls
      local jdtls_path = home .. "/.local/share/nvim/mason/packages/jdtls"
      local config_dir = jdtls_path .. "/config_linux"
      local plugins_dir = jdtls_path .. "/plugins/"
      local lombok_path = plugins_dir .. "lombok.jar"

      -- Main jdtls configuration
      local config = {
        cmd = {
          "java",
          "-Declipse.application=org.eclipse.jdt.ls.core.id1",
          "-Dosgi.bundles.defaultStartLevel=4",
          "-Declipse.product=org.eclipse.jdt.ls.core.product",
          "-Dlog.protocol=true",
          "-Dlog.level=ALL",
          "-Xms1g",
          "--add-modules=ALL-SYSTEM",
          "--add-opens", "java.base/java.util=ALL-UNNAMED",
          "--add-opens", "java.base/java.lang=ALL-UNNAMED",
          "-javaagent:" .. lombok_path,
          "-jar", vim.fn.glob(plugins_dir .. "org.eclipse.equinox.launcher_*.jar"),
          "-configuration", config_dir,
          "-data", home .. "/.cache/jdtls/workspace/" .. vim.fn.fnamemodify(root_dir, ":p:h:t"),
        },
        root_dir = root_dir,
        settings = {
          java = {
            configuration = {
              runtimes = {
                {
                  name = "JavaSE-17",
                  path = "/usr/lib/jvm/java-17-openjdk/", -- Adjust this path based on your system
                },
                {
                  name = "JavaSE-11",
                  path = "/usr/lib/jvm/java-11-openjdk/", -- Adjust this path based on your system
                },
                {
                  name = "JavaSE-1.8",
                  path = "/usr/lib/jvm/java-8-openjdk/", -- Adjust this path based on your system
                },
              },
            },
            eclipse = {
              downloadSources = true,
            },
            maven = {
              downloadSources = true,
            },
            implementationsCodeLens = {
              enabled = true,
            },
            referencesCodeLens = {
              enabled = true,
            },
            references = {
              includeDecompiledSources = true,
            },
            format = {
              enabled = true,
            },
          },
          signatureHelp = { enabled = true },
          completion = {
            favoriteStaticMembers = {
              "org.hamcrest.MatcherAssert.assertThat",
              "org.hamcrest.Matchers.*",
              "org.hamcrest.CoreMatchers.*",
              "org.junit.jupiter.api.Assertions.*",
              "java.util.Objects.requireNonNull",
              "java.util.Objects.requireNonNullElse",
              "org.mockito.Mockito.*",
            },
            filteredTypes = {
              "com.sun.*",
              "io.micrometer.shaded.*",
              "java.awt.*",
              "jdk.*",
              "sun.*",
            },
          },
          contentProvider = { preferred = "fernflower" },
          sources = {
            organizeImports = {
              starThreshold = 9999,
              staticStarThreshold = 9999,
            },
          },
          codeGeneration = {
            toString = {
              template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
            },
            useBlocks = true,
          },
        },
        init_options = {
          bundles = {},
        },
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
      }

      -- Setup jdtls for Java files
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "java",
        callback = function()
          jdtls.start_or_attach(config)

          -- Add keymap for Java-specific functions
          local opts = { noremap = true, silent = true, buffer = vim.api.nvim_get_current_buf() }
          vim.keymap.set("n", "<leader>ji", jdtls.organize_imports, opts)
          vim.keymap.set("n", "<leader>jt", jdtls.test_class, opts)
          vim.keymap.set("n", "<leader>jn", jdtls.test_nearest_method, opts)
          vim.keymap.set("n", "<leader>jr", jdtls.compile_workspace, opts)
        end,
      })
    end,
  },

  -- Ensure we have all needed formatting tools
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        -- Typescript/Javascript
        "typescript-language-server",
        "eslint-lsp",
        "prettier",

        -- Java
        "jdtls",
        "google-java-format",

        -- C/C++
        "clangd",
        "clang-format",

        -- Python
        "pyright",
        "black",
        "isort",
        "ruff",
        "ruff-lsp",

        -- Rust
        "rust-analyzer",
        "rustfmt",

        -- Go
        "gopls",
        "gofumpt",
        "goimports-reviser",
        "golangci-lint",
        "golangci-lint-langserver",

        -- General
        "codelldb", -- Debugger
      })
    end,
  },

  -- Configure formatters
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        -- TypeScript/JavaScript
        ["javascript"] = { "prettier" },
        ["javascriptreact"] = { "prettier" },
        ["typescript"] = { "prettier" },
        ["typescriptreact"] = { "prettier" },
        ["vue"] = { "prettier" },

        -- Java
        ["java"] = { "google_java_format" },

        -- C/C++
        ["c"] = { "clang_format" },
        ["cpp"] = { "clang_format" },

        -- Python
        ["python"] = { "isort", "black" },

        -- Rust
        ["rust"] = { "rustfmt" },

        -- Go
        ["go"] = { "gofumpt", "goimports-reviser" },
      },
    },
  },

  -- Configure linters
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = {
      linters_by_ft = {
        -- TypeScript/JavaScript
        ["javascript"] = { "eslint" },
        ["typescript"] = { "eslint" },
        ["javascriptreact"] = { "eslint" },
        ["typescriptreact"] = { "eslint" },

        -- Python
        ["python"] = { "ruff" },

        -- Go
        ["go"] = { "golangcilint" },
      },
    },
  },

  -- Add debugging capability
  {
    "mfussenegger/nvim-dap",
    optional = true,
    dependencies = {
      -- dap UI interfaces
      "rcarriga/nvim-dap-ui",
      -- Add virtual text for debugging
      "theHamsta/nvim-dap-virtual-text",
      -- Debugger for many languages
      {
        "jay-babu/mason-nvim-dap.nvim",
        dependencies = "williamboman/mason.nvim",
        opts = {
          handlers = {},
        },
      },
      -- Telescope extensions for dap
      { "nvim-telescope/telescope-dap.nvim" },
    },
    config = function()
      local dap = require("dap")

      -- Configure various adapters
      -- Python
      dap.adapters.python = {
        type = "executable",
        command = "python",
        args = { "-m", "debugpy.adapter" },
      }

      dap.configurations.python = {
        {
          type = "python",
          request = "launch",
          name = "Launch file",
          program = "${file}",
          pythonPath = function()
            return "/usr/bin/python"
          end,
        },
      }

      -- C/C++/Rust
      dap.adapters.codelldb = {
        type = "server",
        port = "${port}",
        executable = {
          command = "codelldb",
          args = { "--port", "${port}" },
        },
      }

      dap.configurations.cpp = {
        {
          name = "Launch file",
          type = "codelldb",
          request = "launch",
          program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
        },
      }
      dap.configurations.c = dap.configurations.cpp
      dap.configurations.rust = dap.configurations.cpp

      -- Go
      dap.adapters.delve = {
        type = "server",
        port = "${port}",
        executable = {
          command = "dlv",
          args = { "dap", "-l", "127.0.0.1:${port}" },
        },
      }

      dap.configurations.go = {
        {
          type = "delve",
          name = "Debug",
          request = "launch",
          program = "${file}",
        },
      }

      -- Java
      dap.configurations.java = {
        {
          type = "java",
          request = "attach",
          name = "Debug (Attach) - Remote",
          hostName = "127.0.0.1",
          port = 5005,
        },
      }
    end,
  },
}