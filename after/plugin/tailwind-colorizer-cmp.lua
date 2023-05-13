local status, tailwindcssColorizer = pcall(require, "tailwindcss-colorizer-cmp")
if not status then
	return
end

tailwindcssColorizer.setup({
	color_square_width = 2,
})
