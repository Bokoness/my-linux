function dotenv
    export (grep -v '^#' .env | xargs -L 1)
end
