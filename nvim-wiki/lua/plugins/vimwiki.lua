return {
  "vimwiki/vimwiki", 
    init = function() 
        vim.g.vimwiki_list = {
            {
            path = '~/Documents/wiki/',
            syntax = 'default',
            ext = '.md',
            },
          }
		    vim.g.vimwiki_syntax_plugins = {
			  codeblock = {
				  ["```lua"] = { parser = "lua" },
				  ["```python"] = { parser = "python" },
				  ["```javascript"] = { parser = "javascript" },
				  ["```bash"] = { parser = "bash" },
				  ["```html"] = { parser = "html" },
				  ["```css"] = { parser = "css" },
				  ["```c"] = { parser = "c" },
			  },
		  }
    end,
}
