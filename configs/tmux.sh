session="work"

# Set up tmux
tmux start-server

# 0: Open the projects directory
tmux new-session -d -s $session -n development
tmux send-keys "cd ~/projects" C-m 

# 1: Create a new window called vim
tmux new-window -t $session:1 -n vim
tmux send-keys "cd ~/projects" C-m 
tmux send-keys "vim ." C-m 

# 2: Create a new window called infos
tmux new-window -t $session:2 -n infos
tmux send-keys "cd ~/projects" C-m 
tmux send-keys "dust" C-m 

tmux split-window -h
tmux send-keys "cd ~/projects" C-m 
tmux send-keys "duf" C-m 

tmux split-window -v
tmux send-keys "cd ~/projects" C-m 
tmux send-keys "ps" Enter C-m 

tmux selectp -t 0
tmux splitw -v
tmux send-keys "cd ~/projects" C-m 
tmux send-keys "ping google.com" C-m 
tmux selectp -t 0

# 3: Create a new window called browser
tmux new-window -t $session:3 -n browser
tmux send-keys "cd ~/projects" C-m 
tmux send-keys "w3m -no-cookie 'https://duckduckgo.com'" C-m 

# 4: Create a new window called downloads
tmux new-window -t $session:4 -n downloads
tmux send-keys "cd ~/downloads" C-m

# 5: Create a new window called containers
tmux new-window -t $session:5 -n containers
tmux send-keys "cd ~/projects" C-m
tmux send-keys "podman info" C-m

# Return to the main development window
tmux select-window -t $session:1

# Finished setup, attach to the tmux session
tmux attach-session -t $session
