import os.path as ops
import numpy as np
import torch
import cv2
import time
import os
import matplotlib.pylab as plt
import sys
from tqdm import tqdm
import imageio
from dataset.dataset_utils import TUSIMPLE
from Lanenet.model2 import Lanenet
from utils.evaluation import gray_to_rgb_emb, process_instance_embedding, video_to_clips
import argparse

torch.backends.cudnn.enabled = False

# Argument setting
parser = argparse.ArgumentParser()
parser.add_argument("--frame-dir", type=str, default="./TUSIMPLE/test_clips/1494452927854312215")
parser.add_argument("--gif-dir", type=str, default="/home/foscar/test_ws/src/LaneNet-PyTorch/TUSIMPLE/gif_output")
parser.add_argument("--device", type=str, default='cpu')
args = parser.parse_args()

# Load the Model
model_path = './TUSIMPLE/Lanenet_output/lanenet_epoch_39_batch_8.model'
LaneNet_model = Lanenet(2, 4)
LaneNet_model.load_state_dict(torch.load(model_path, map_location=torch.device(args.device)))
LaneNet_model.to(args.device)

# Inference
def clips_to_gif(test_clips_root, git_root):
    img_paths = []
    for img_name in os.listdir(test_clips_root):
        img_paths.append(ops.join(test_clips_root,img_name))
    img_paths.sort()
    gif_frames = []
    for i, img_name in enumerate(img_paths):
        gt_img_org = cv2.imread(img_name, cv2.IMREAD_UNCHANGED)
        org_shape = gt_img_org.shape
        gt_image = cv2.resize(gt_img_org, dsize=(512, 256), interpolation=cv2.INTER_LINEAR)
        gt_image = gt_image / 127.5 - 1.0
        gt_image = torch.tensor(gt_image, dtype=torch.float)
        gt_image = np.transpose(gt_image, (2, 0, 1))
        gt_image = gt_image.to(args.device)
        binary_final_logits, instance_embedding = LaneNet_model(gt_image.unsqueeze(0))
        binary_final_logits, instance_embedding = binary_final_logits.to('cpu'), instance_embedding.to('cpu')
        binary_img = torch.argmax(binary_final_logits, dim=1).squeeze().numpy()
        binary_img[0:65,:] = 0
        rbg_emb, cluster_result = process_instance_embedding(instance_embedding, binary_img,
                                                             distance=1.5, lane_num=4)

        rbg_emb = cv2.resize(rbg_emb, dsize=(org_shape[1], org_shape[0]), interpolation=cv2.INTER_LINEAR)
        a = 0.6
        frame = a * gt_img_org[..., ::-1] / 255 + rbg_emb * (1 - a)
        frame = np.rint(frame * 255)
        frame = frame.astype(np.uint8)
        gif_frames.append(frame)
    imageio.mimsave(git_root, gif_frames, fps=5)


if os.path.isdir(args.frame_dir):
    video_name = os.path.basename(args.frame_dir)
else:
    print('frame_dir is not directory')

print('Pdrocess the clip {} \n'.format(video_name))
git_root = ops.join(args.gif_dir, video_name) + '.gif'

start_time = time.time()
clips_to_gif(args.frame_dir, git_root)
print(time.time() - start_time)