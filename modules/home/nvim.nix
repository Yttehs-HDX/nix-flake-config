{
  inputs,
  lib,
  pkgs,
  ...
}:

{
  imports = [ inputs.nixvim.homeModules.nixvim ];

  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    nixpkgs.useGlobalPackages = true;
    extraPackages = with inputs.nixpkgs.legacyPackages.x86_64-linux; [
      gcc
      clang
      gnumake
      pkg-config
    ];

    opts = {
      number = true;
      relativenumber = true;
      shiftwidth = 2;
    };

    plugins = {
      lualine.enable = true;
      bufferline.enable = true;
      web-devicons.enable = true;
      treesitter = {
        enable = true;
        settings = {
          auto_install = true;
          highlight.enable = true;
          incremental_selection.enable = true;
          indent.enable = true;
        };
      };
      noice.enable = true;
      nvim-tree = {
        enable = true;
        openOnSetup = true;
      };
      cmp = {
        enable = true;
        settings = {
          sources = [
            { name = "buffer"; }
            { name = "path"; }
            { name = "conventionalcommits"; }
            { name = "git"; }
            { name = "zsh"; }
            { name = "calc"; }
            { name = "emoji"; }
            { name = "treesitter"; }
          ];
          mapping = {
            "<Tab>" = "cmp.mapping.select_next_item()";
            "<S-Tab>" = "cmp.mapping.select_prev_item()";
            "<CR>" = "cmp.mapping.confirm({ select = true })";
          };
        };
      };
      cmp-buffer.enable = true;
      cmp-path.enable = true;
      cmp-conventionalcommits.enable = true;
      cmp-git.enable = true;
      cmp-zsh.enable = true;
      cmp-calc.enable = true;
      cmp-emoji.enable = true;
      copilot-lua = {
        enable = true;
        package = pkgs.vimUtils.buildVimPlugin {
          pname = "copilot.lua";
          version = "3.0.0-pinned";
          src = pkgs.fetchFromGitHub {
            owner = "zbirenbaum";
            repo = "copilot.lua";
            rev = "cff29d14b2ff2c8d231ba47653fe2125f497053e";
            hash = "sha256-lfma6pmMPVs4AOwkj69UoSI6Ue7RW4rOuwa1+G5UJ50=";
          };
          # Neovim 0.12 opens LSP documents at version 0, independently of changedtick.
          postPatch = ''
            substituteInPlace lua/copilot/util.lua \
              --replace-fail 'version = vim.api.nvim_buf_get_var(0, "changedtick"),' \
              'version = vim.lsp.util.buf_versions[vim.api.nvim_get_current_buf()] or vim.api.nvim_buf_get_var(0, "changedtick"),'
          '';
        };
        settings.server = {
          type = "nodejs";
          custom_server_filepath = "${pkgs.copilot-language-server}/share/copilot-language-server/main.js";
        };
        settings.suggestion.auto_trigger = true;
        settings.filetypes = {
          "." = false;
          cvs = false;
          gitcommit = true;
          gitrebase = true;
          help = false;
          hgcommit = false;
          markdown = false;
          svn = false;
          yaml = true;
        };
      };
      # nixpkgs' copilot-cmp currently depends on the retagged copilot.lua v2.0.4.
      copilot-cmp.enable = lib.mkForce false;
      copilot-chat.enable = lib.mkForce false;
      render-markdown.enable = true;
      markdown-preview.enable = true;
      lsp = {
        enable = true;
        servers = {
          pyright.enable = true;
          rust_analyzer = {
            enable = true;
            installCargo = true;
            installRustc = true;
          };
          ts_ls.enable = true;
          lua_ls.enable = true;
          gopls.enable = true;
          clangd.enable = true;
          html.enable = true;
          cssls.enable = true;
          jsonls.enable = true;
          yamlls.enable = true;
          bashls.enable = true;
          dockerls.enable = true;
          sqls.enable = true;
          texlab.enable = true;
        };
        keymaps = {
          lspBuf = {
            "gd" = "definition";
            "gD" = "declaration";
            "gi" = "implementation";
            "go" = "type_definition";
            "gr" = "references";
            "K" = "hover";
            "<C-k>" = "signature_help";
            "<leader>rn" = "rename";
            "<leader>ca" = "code_action";
            "<leader>f" = "format";
          };
          diagnostic = {
            "[d" = "goto_prev";
            "]d" = "goto_next";
            "<leader>e" = "open_float";
            "<leader>q" = "setloclist";
          };
        };
      };
      notify = {
        enable = true;
        settings.timeout = 500;
      };
      trouble.enable = true;
      nvim-lightbulb.enable = true;
    };
  };
}
