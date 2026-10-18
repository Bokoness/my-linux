
function run_hg_env
    # Change directory to the project folder
    cd /home/bkooness/hg/back-office

    # Run npm run adonis-dev --debug in the current terminal
    npm run adonis-dev --debug &

    # Open a new terminal window and run nvim
    tmux new -s dev_env nvim

    # Run npm run dev in a detached background process
    tmux send-keys -t dev_env "npm run dev" C-m
end
