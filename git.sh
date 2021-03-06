#!/bin/bash

set -e

source utils/setup_function.sh

main()
{
	create="false"
	delete="false"
	remove="false"
	private="false"
	add="false"
  if [ $# -eq 0 ]; then
      usage
  fi

  while [[ $# -gt 0 ]]; do
    option="$1"
    case ${option} in
    -c | --create-repo)
			create="true"
      shift
      ;;
		-r | --repo-name)
			repo=$2
			shift 2
			;;
		-o | --org)
			org=$2
			shift 2
			;;
		-u | --username)
			user=$2
			shift 2
			;;
		-n | --collaborator-name)
			name=$2
			shift 2
			;;
		-R | --remove-collaborator)
			remove="true"
			shift
			;;
		-t | --teamname)
			teamname=$2
			shift 2
			;;
		-p | --permission)
			if [ "$2" = "admin" ];
			then
				 permission="admin"
			elif [ "$2" = "write" ];
			then
				 permission="push"
			elif [ "$2" = "read" ];
			then
				 permission="pull"
			else
				printf "enter valid permissions"
			fi
			shift 2
			;;
		-a | --add-collaborator)
			 add="true"
			shift
			;;
		-d | --delete-repo)
			 delete="true"
			shift
			;;
		--private)
			private="true"
			shift
			;;
		-h | --help)
			usage
			;;
		*)
      usage
      POSITIONAL+=("$1") # save it in an array for later
      shift              # past argument
      ;;
		esac
  done

	if [ -n $repo ] && [ ! $user = "" ] && [ $create = "true" ];
	then
		add_repo
	elif [ -n $repo ] && [ ! $org = "" ] && [ $create = "true" ];
	then
		add_repo_org
	elif [ -n $repo ] && [ $delete = "true" ];
	then
		delete_repo
	elif [ -n $repo ] && [ $add = "true" ] && [ ! $name = "" ];
	then
		add_collaborator
	elif [ -n $repo ] && [ $add = "true" ] && [ ! $teamname = "" ];
	then
		add_team_collaborator
	elif [ -n $repo ] && [ $remove = "true" ] && [ ! $name = "" ] && [ -z $teamname ];
	then
		remove_collaborator
	elif [ -n $repo ] && [ $remove = "true" ] && [ ! $teamname = "" ];
	then
		remove_team_collaborator
	else
		usage
	fi

	unset -- "${POSITIONAL[@]}"
}

main "$@"