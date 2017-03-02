function fish_right_prompt
  set -l cwd

  set -l ahead    "↑"
  set -l behind   "↓"
  set -l diverged "⥄ "
  set -l dirty    "✘"
  set -l none     "✔"

  set -l directory_color  (set_color $fish_color_quote ^/dev/null; or set_color brown)
  set -l repository_color (set_color $fish_color_cwd ^/dev/null; or set_color green)

  if test "$theme_short_path" = 'yes'
    set cwd (basename (prompt_pwd))
  else
    set cwd (prompt_pwd)
  end

  if git_is_repo
    if test "$theme_short_path" = 'yes'
      set root_folder (command git rev-parse --show-toplevel ^/dev/null)
      set parent_root_folder (dirname $root_folder)
      set cwd (echo $PWD | sed -e "s|$parent_root_folder/||")

      echo -n -s $directory_color $cwd $normal_color
    else
      echo -n -s $directory_color $cwd $normal_color
    end

    echo -n -s $repository_color " " (git_branch_name) $normal_color " "

    if git_is_touched
      echo -n -s $dirty
    else
      echo -n -s (git_ahead $ahead $behind $diverged $none)
    end
  else
    echo -n -s $directory_color $cwd $normal_color
  end

  echo -n -s " "

  set_color $fish_color_autosuggestion ^/dev/null; or set_color 555
  date "+%H:%M"
  set_color normal

end
