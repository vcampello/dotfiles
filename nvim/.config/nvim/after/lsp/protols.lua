return {
    before_init = function(_, config)
        config.init_options = {
            include_paths = {
                "/usr/local/include/protobuf",
                "/opt/homebrew/include/protobuf",
            },
        }
    end,
}
