local status, nvimSurround = pcall(require, 'nvim-surround')

if not status then
  return
end

nvimSurround.setup({})
