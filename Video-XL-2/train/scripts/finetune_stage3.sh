# export OMP_NUM_THREADS=8
# export NCCL_IB_DISABLE=0
# export NCCL_IB_GID_INDEX=3
cd /share/LXRlxr0_0/code/videoxl2/videoxl2
source activate /share/LXRlxr0_0/env/xl
export OMP_NUM_THREADS=1

torchrun \
    --nnodes=$WORLD_SIZE \
    --nproc_per_node=8 \
    --master_addr=$MASTER_ADDR \
    --master_port=$MASTER_PORT \
    --node_rank=$RANK \
    longva/longva/train/train_mem.py \
    --deepspeed /share/LXRlxr0_0/code/videoxl2/videoxl2/zero1_qin.json \
    --model_name_or_path /share/LXRlxr0_0/code/Qwen/Qwen2.5-7B-Instruct \
    --version qwen_1_5  \
    --data_path /share/LXRlxr0_0/code/videoxl2/videoxl2/sum2.json \
    --image_folder /share/ \
    --video_folder /share/ \
    --vision_tower  /share/LXRlxr0_0/code/videoxlturbo2.0/videoxl/google/siglip-so400m-patch14-384 \
    --pretrain_mm_mlp_adapter /share/LXRlxr0_0/code/videoxlturbo2.0/LongVA_stage2/checkpoints/pretrain_0308_qwen2.5_7b/mm_projector.bin \
    --mm_projector_type mlp2x_gelu \
    --video_fps 1 \
    --frames_upbound 16 \
    --image_aspect_ratio anyres \
    --group_by_modality_length True \
    --unfreeze_mm_vision_tower True \
    --mm_spatial_pool_stride 2 \
    --mm_resampler_type "spatial_pool" \
    --mm_spatial_pool_out_channels 1152 \
    --mm_vision_select_feature patch \
    --image_grid_pinpoints "(1x1)...(6x6)"  \
    --mm_patch_merge_type unires \
    --mm_use_im_start_end False \
    --mm_use_im_patch_token False \
    --bf16 True \
    --output_dir checkpoints/videoxl2_0410 \
    --num_train_epochs 1 \
    --per_device_train_batch_size 1 \
    --per_device_eval_batch_size 4 \
    --gradient_accumulation_steps 8 \
    --evaluation_strategy "no" \
    --save_strategy "steps" \
    --save_steps 1000 \
    --save_total_limit 1 \
    --learning_rate 1.0e-5 \
    --weight_decay 0. \
    --warmup_ratio 0.03 \
    --lr_scheduler_type "cosine" \
    --logging_steps 1 \
    --tf32 True \
    --model_max_length 8192 \
    --gradient_checkpointing True \
    --dataloader_num_workers 8 \
    --lazy_preprocess True \
    --run_name finetune_i \
    --group_by_stride strict \