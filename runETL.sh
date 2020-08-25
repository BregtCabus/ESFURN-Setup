if [ $(docker ps --filter "name=etl" | grep -w 'etl' | wc -l) = 1 ]; then
  docker stop -t 1 etl && docker rm etl;
fi

rm -rf ./docker-compose.yml*
cp ./docker-compose-template.yml ./docker-compose.yml

read -p "DB User [postgres]: " db_user
db_user=${db_user:-postgres}
read -p "DB Name [postgres]: " db_password
db_password=${db_password:-postgres}

read -p "Input Data folder [./data]: " data_folder
data_folder=${data_folder:-./data}
read -p "Input Data file [data.xlsx]: " input_data
input_data=${input_data:-data.xlsx}
read -p "Diagnosis Code mapping file [diagnosis_code_mapping.csv]: " diagn_file
diagn_file=${diagn_file:-diagnosis_code_mapping.csv}
read -p "Drug Code mapping file [drug_code_mapping.csv]: " drug_file
drug_file=${drug_file:-drug_code_mapping.csv}
read -p "Site Collection mapping file [site_collection_mapping.csv]: " site_file
site_file=${site_file:-site_collection_mapping.csv}
read -p "Output verbosity level [INFO]: " verbosity_level
verbosity_level=${verbosity_level:-INFO}
read -p "Docker Hub image tag [latest]: " image_tag
image_tag=${image_tag:-latest}

sed -i -e "s@data_folder@$data_folder@g" docker-compose.yml
sed -i -e "s/input_data/$input_data/g" docker-compose.yml
sed -i -e "s/diagnosis_code_mapping/$diagn_file/g" docker-compose.yml
sed -i -e "s/drug_code_mapping/$drug_file/g" docker-compose.yml
sed -i -e "s/site_collection_mapping/$site_file/g" docker-compose.yml
sed -i -e "s/verbosity_level/$verbosity_level/g" docker-compose.yml
sed -i -e "s/image_tag/$image_tag/g" docker-compose.yml

docker login
docker-compose pull
docker-compose run --rm --name etl etl




