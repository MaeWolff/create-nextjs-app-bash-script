#
# Create new next.js project.
# Author: @MaeWolff - Maxence WOLFF
#

##### COLORS #####
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
GREY='\033[0;90m'
NOCOLOR='\033[0m'
####################

choose_package_manager() {
    echo "Which package manager do you want to use?"
    echo "a) npm"
    echo "b) yarn"
    echo "c) pnpm"
    echo "d) bun"
    read -p "Select an option (a-d): " package_manager_option

    case $package_manager_option in
    a)
        package_manager="npm"
        ;;
    b)
        package_manager="yarn"
        ;;
    c)
        package_manager="pnpm"
        ;;
    d)
        package_manager="bun"
        ;;
    *)
        echo -e "${RED}Invalid option. Using npm by default.${NOCOLOR}"
        package_manager="npm"
        ;;
    esac
}

remove_file() {
    local file_path=$1
    if [ -f "$file_path" ]; then
        rm "$file_path"
        echo "File $file_path removed."
    else
        echo "File $file_path does not exist."
    fi
}

#
#  MAIN
#

echo -e "${BLUE}–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––${NOCOLOR}"

choose_package_manager

read -p "What is your project named? " project_name
npx create-next-app@latest "--use-$package_manager" "$project_name"

cd $project_name

echo -e "${GREY}Fixing styles files...${NOCOLOR}"
remove_file "src/app/globals.css"
mkdir -p src/styles

echo '@tailwind base;
@tailwind components;
@tailwind utilities;' >src/styles/tailwind.css

sed -i '' -e 's|import \("./globals.css"\);|import \"../styles/tailwind.css"\;|' src/app/layout.tsx

echo -e "${BLUE}–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––${NOCOLOR}"

echo -e "${GREY}Adding prettier plugins...${NOCOLOR}"
$package_manager install -D prettier prettier-plugin-tailwindcss

echo '{
  "plugins": ["prettier-plugin-tailwindcss"]
}' >.prettierrc

echo -e "${BLUE}–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––${NOCOLOR}"

echo -e "${GREY}Managing dependencies installation...${NOCOLOR}"
read -p "Do you want to install react-query and zod? (y/n): " install_react_query
if [ "$install_react_query" == "y" ]; then
    $package_manager install @tanstack/react-query zod @types/react-query
fi

read -p "Do you want to install vitest? (y/n): " install_vitest
if [ "$install_vitest" == "y" ]; then
    $package_manager install vitest -D
fi

echo -e "${GREEN}                             Done!                             ${NOCOLOR}"
echo -e "${GREEN}–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––${NOCOLOR}"
