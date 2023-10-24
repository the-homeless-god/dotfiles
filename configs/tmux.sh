# Define variables
projects_dir="$HOME/projects"
downloads_dir="$HOME/downloads"
session="work"

# Create a function to open windows
open_project_window() {
  window_index="$1"
  window_name="$2"
  command="$3"
  tmux new-window -t $session:$window_index -n $window_name
  tmux send-keys "cd $projects_dir" C-m
  tmux send-keys "$command" C-m
}

# Set up tmux
tmux start-server

# 0: Open the projects directory and run 'vim .'
open_project_window 0 development "vim ."

# 1: Open the projects directory and run 'dust'
open_project_window 1 infos "dust"

# 2: Open the projects directory, run 'duf', and split the window
open_project_window 2 infos "duf"
tmux split-window -h
tmux send-keys "cd $projects_dir" C-m
tmux send-keys "ps" Enter C-m

# 3: Open the projects directory and run 'ping google.com'
open_project_window 3 browser "ping google.com"

# 4: Open the downloads directory
open_project_window 4 downloads ""

# 5: Open the projects directory and run 'podman info'
open_project_window 5 containers "podman info"

# Return to the main development window
tmux select-window -t $session:0

# Finished setup, attach to the tmux session
tmux attach-session -t $session
