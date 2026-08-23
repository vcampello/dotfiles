local function read_lines(filename)
	local file = io.open(filename, "r")

	if file == nil then
		print("failed to read " .. filename)
		return
	end

	for line in file:lines() do
		print("line: " .. line)
	end

	io.close(file)
end

read_lines("./CODEOWNERS")
