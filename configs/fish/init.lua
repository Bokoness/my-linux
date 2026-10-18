-- This file can be found at ~/.config/nvim/init.lua

-- Auto-install packer.nvim if it's not already installed
local fn = vim.fn
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
  vim.cmd [[packadd packer.nvim]]
end

-- Packer configuration
require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- Telescope for fuzzy finding
  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.x',
    requires = { {'nvim-lua/plenary.nvim'} }
  }

  -- Treesitter for syntax highlighting
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate'
  }

  -- A popular colorscheme
  use 'folke/tokyonight.nvim'

  -- Automatically run PackerSync whenever this file is updated
  if Packer_Bootstrap then
    require('packer').sync()
  end
end)

-- Basic settings
vim.opt.termguicolors = true
vim.cmd [[colorscheme tokyonight]]
