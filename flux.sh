#!/bin/bash

source /venv/main/bin/activate
COMFYUI_DIR=${WORKSPACE}/ComfyUI

# Packages are installed after nodes so we can fix them...

APT_PACKAGES=(
    #"package-1"
    #"package-2"
)

PIP_PACKAGES=(
    #"package-1"
    #"package-2"
)

NODES=(
    "https://github.com/ltdrdata/ComfyUI-Manager"
    "https://github.com/cubiq/ComfyUI_essentials"
    "https://github.com/kijai/ComfyUI-HunyuanVideoWrapper"
    "https://github.com/city96/ComfyUI-GGUF"
    "https://github.com/cubiq/ComfyUI_IPAdapter_plus"
    "https://github.com/Kosinkadink/ComfyUI-AnimateDiff-Evolved"
    "https://github.com/Fannovel16/comfyui_controlnet_aux"
    "https://github.com/ltdrdata/ComfyUI-Impact-Pack"
    "https://github.com/pythongosssss/ComfyUI-Custom-Scripts"
    "https://github.com/huchenlei/ComfyUI-layerdiffuse"
    "https://github.com/rgthree/rgthree-comfy"
    "https://github.com/shadowcz007/comfyui-mixlab-nodes"
    "https://github.com/WASasquatch/was-node-suite-comfyui"
    "https://github.com/yolain/ComfyUI-Easy-Use"
    "https://github.com/mcmonkeyprojects/sd-dynamic-thresholding"
    "https://github.com/jags111/efficiency-nodes-comfyui"
    "https://github.com/ssitu/ComfyUI_UltimateSDUpscale"
    "https://github.com/crystian/ComfyUI-Crystools"
    "https://github.com/kijai/ComfyUI-Florence2"
    "https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite"
    "https://github.com/kijai/ComfyUI-KJNodes"
    "https://github.com/Kosinkadink/ComfyUI-Advanced-ControlNet"
    "https://github.com/cubiq/ComfyUI_essentials"
    "https://github.com/chrisgoringe/cg-use-everywhere"
    "https://github.com/Fannovel16/ComfyUI-Frame-Interpolation"
    "https://github.com/melMass/comfy_mtb"
    "https://github.com/ltdrdata/ComfyUI-Inspire-Pack"
    "https://github.com/FizzleDorf/ComfyUI_FizzNodes"
    "https://github.com/Derfuu/Derfuu_ComfyUI_ModdedNodes"
    "https://github.com/asagi4/comfyui-prompt-control"
    "https://github.com/sipherxyz/comfyui-art-venture"
    "https://github.com/pamparamm/ComfyUI-ppm"
    "https://github.com/gseth/ControlAltAI-Nodes"
    "https://github.com/nkchocoai/ComfyUI-PromptUtilities"
    "https://github.com/banodoco/steerable-motion"
    "https://github.com/twri/sdxl_prompt_styler"
    "https://github.com/Suzie1/ComfyUI_Comfyroll_CustomNodes"
    "https://github.com/city96/ComfyUI_ExtraModels"
    "https://github.com/BadCafeCode/masquerade-nodes-comfyui"
    "https://github.com/BlenderNeko/ComfyUI_ADV_CLIP_emb"
    "https://github.com/giriss/comfy-image-saver"
    "https://github.com/flowtyone/ComfyUI-Flowty-LDSR"
    "https://github.com/glibsonoran/Plush-for-ComfyUI"
    "https://github.com/omar92/ComfyUI-QualityOfLifeSuit_Omar92"
    "https://github.com/SeaArtLab/ComfyUI-Long-CLIP"
    "https://github.com/jamesWalker55/comfyui-various"
    "https://github.com/kadirnar/ComfyUI-YOLO"
    "https://github.com/kinfolk0117/ComfyUI_GradientDeepShrink"
    "https://github.com/picturesonpictures/comfy_PoP"
    "https://github.com/un-seen/comfyui-tensorops"
    "https://github.com/ronsantash/Comfyui-flexi-lora-loader"
)

WORKFLOWS=(
    "https://gist.githubusercontent.com/robballantyne/f8cb692bdcd89c96c0bd1ec0c969d905/raw/2d969f732d7873f0e1ee23b2625b50f201c722a5/flux_dev_example.json"
)

CLIP_MODELS=(
    "https://huggingface.co/comfyanonymous/flux_text_encoders/resolve/main/clip_l.safetensors"
    "https://huggingface.co/comfyanonymous/flux_text_encoders/resolve/main/t5xxl_fp16.safetensors"
    "https://huggingface.co/Comfy-Org/HunyuanVideo_repackaged/resolve/main/split_files/text_encoders/clip_l.safetensors"
    "https://huggingface.co/Comfy-Org/HunyuanVideo_repackaged/resolve/main/split_files/text_encoders/llava_llama3_fp8_scaled.safetensors"
)

UNET_MODELS=(
    "https://huggingface.co/city96/HunyuanVideo-gguf/resolve/main/hunyuan-video-t2v-720p-Q5_0.gguf"
    "https://huggingface.co/Kijai/HunyuanVideo_comfy/resolve/6e02d99d3e62501ed5533cd7e174153012cf18c0/hunyuan_video_720_fp8_e4m3fn.safetensors"
)

VAE_MODELS=(
    "https://huggingface.co/Kijai/HunyuanVideo_comfy/resolve/main/hunyuan_video_vae_bf16.safetensors"
)

### DO NOT EDIT BELOW HERE UNLESS YOU KNOW WHAT YOU ARE DOING ###

function provisioning_start() {
    provisioning_print_header
    provisioning_get_apt_packages
    provisioning_get_nodes
    provisioning_get_pip_packages
    workflows_dir="${COMFYUI_DIR}/user/default/workflows"
    mkdir -p "${workflows_dir}"
    provisioning_get_files \
        "${workflows_dir}" \
        "${WORKFLOWS[@]}"
    # Get licensed models if HF_TOKEN set & valid
    if provisioning_has_valid_hf_token; then
        UNET_MODELS+=("https://huggingface.co/black-forest-labs/FLUX.1-dev/resolve/main/flux1-dev.safetensors")
        VAE_MODELS+=("https://huggingface.co/black-forest-labs/FLUX.1-dev/resolve/main/ae.safetensors")
    else
        UNET_MODELS+=("https://huggingface.co/black-forest-labs/FLUX.1-schnell/resolve/main/flux1-schnell.safetensors")
        VAE_MODELS+=("https://huggingface.co/black-forest-labs/FLUX.1-schnell/resolve/main/ae.safetensors")
        sed -i 's/flux1-dev\.safetensors/flux1-schnell.safetensors/g' "${workflows_dir}/flux_dev_example.json"
    fi
    provisioning_get_files \
        "${COMFYUI_DIR}/models/unet" \
        "${UNET_MODELS[@]}"
    provisioning_get_files \
        "${COMFYUI_DIR}/models/vae" \
        "${VAE_MODELS[@]}"
    provisioning_get_files \
        "${COMFYUI_DIR}/models/clip" \
        "${CLIP_MODELS[@]}"
    provisioning_print_end
}

function provisioning_get_apt_packages() {
    if [[ -n $APT_PACKAGES ]]; then
            sudo $APT_INSTALL ${APT_PACKAGES[@]}
    fi
}

function provisioning_get_pip_packages() {
    if [[ -n $PIP_PACKAGES ]]; then
            pip install --no-cache-dir ${PIP_PACKAGES[@]}
    fi
}

function provisioning_get_nodes() {
    for repo in "${NODES[@]}"; do
        dir="${repo##*/}"
        path="${COMFYUI_DIR}custom_nodes/${dir}"
        requirements="${path}/requirements.txt"
        if [[ -d $path ]]; then
            if [[ ${AUTO_UPDATE,,} != "false" ]]; then
                printf "Updating node: %s...\n" "${repo}"
                ( cd "$path" && git pull )
                if [[ -e $requirements ]]; then
                   pip install --no-cache-dir -r "$requirements"
                fi
            fi
        else
            printf "Downloading node: %s...\n" "${repo}"
            git clone "${repo}" "${path}" --recursive
            if [[ -e $requirements ]]; then
                pip install --no-cache-dir -r "${requirements}"
            fi
        fi
    done
}

function provisioning_get_files() {
    if [[ -z $2 ]]; then return 1; fi
    
    dir="$1"
    mkdir -p "$dir"
    shift
    arr=("$@")
    printf "Downloading %s model(s) to %s...\n" "${#arr[@]}" "$dir"
    for url in "${arr[@]}"; do
        printf "Downloading: %s\n" "${url}"
        provisioning_download "${url}" "${dir}"
        printf "\n"
    done
}

function provisioning_print_header() {
    printf "\n##############################################\n#                                            #\n#          Provisioning container            #\n#                                            #\n#         This will take some time           #\n#                                            #\n# Your container will be ready on completion #\n#                                            #\n##############################################\n\n"
}

function provisioning_print_end() {
    printf "\nProvisioning complete:  Application will start now\n\n"
}

function provisioning_has_valid_hf_token() {
    [[ -n "$HF_TOKEN" ]] || return 1
    url="https://huggingface.co/api/whoami-v2"

    response=$(curl -o /dev/null -s -w "%{http_code}" -X GET "$url" \
        -H "Authorization: Bearer $HF_TOKEN" \
        -H "Content-Type: application/json")

    # Check if the token is valid
    if [ "$response" -eq 200 ]; then
        return 0
    else
        return 1
    fi
}

function provisioning_has_valid_civitai_token() {
    [[ -n "$CIVITAI_TOKEN" ]] || return 1
    url="https://civitai.com/api/v1/models?hidden=1&limit=1"

    response=$(curl -o /dev/null -s -w "%{http_code}" -X GET "$url" \
        -H "Authorization: Bearer $CIVITAI_TOKEN" \
        -H "Content-Type: application/json")

    # Check if the token is valid
    if [ "$response" -eq 200 ]; then
        return 0
    else
        return 1
    fi
}

# Download from $1 URL to $2 file path
function provisioning_download() {
    if [[ -n $HF_TOKEN && $1 =~ ^https://([a-zA-Z0-9_-]+\.)?huggingface\.co(/|$|\?) ]]; then
        auth_token="$HF_TOKEN"
    elif 
        [[ -n $CIVITAI_TOKEN && $1 =~ ^https://([a-zA-Z0-9_-]+\.)?civitai\.com(/|$|\?) ]]; then
        auth_token="$CIVITAI_TOKEN"
    fi
    if [[ -n $auth_token ]];then
        wget --header="Authorization: Bearer $auth_token" -qnc --content-disposition --show-progress -e dotbytes="${3:-4M}" -P "$2" "$1"
    else
        wget -qnc --content-disposition --show-progress -e dotbytes="${3:-4M}" -P "$2" "$1"
    fi
}

# Allow user to disable provisioning if they started with a script they didn't want
if [[ ! -f /.noprovisioning ]]; then
    provisioning_start
fi
