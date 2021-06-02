DATASET_PATH=/data/G

colmap feature_extractor \
   --database_path $DATASET_PATH/database.db \
   --image_path $DATASET_PATH/images \
   
colmap exhaustive_matcher \
   --database_path $DATASET_PATH/database.db 
   
mkdir $DATASET_PATH/sparse
   
colmap mapper \
    --database_path $DATASET_PATH/database.db \
    --image_path $DATASET_PATH/images \
    --output_path $DATASET_PATH/sparse \
    
    %--For permissive mapping
    %--Mapper.init_min_num_inliers 30

    %--For peak threshold tuning
    %--SiftExtraction.max_num_features 5000 
    %--SiftExtraction.peak_threshold 0.0015
    %--SiftExtraction.edge_threshold 10
