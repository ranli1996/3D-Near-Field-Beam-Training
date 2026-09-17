# 3D Near-Field Beam Training for Uniform Planar Arrays

This repository contains the MATLAB implementation and simulation codes for the paper:

**R. Li, Z. Xu, and Y.-J. A. Zhang,  
"3D Near-Field Beam Training for Uniform Planar Arrays: Low-Overhead Approaches Leveraging Beam Diverging,"  
IEEE Trans. Wireless Commun., Aug. 2026

Paper: https://ieeexplore.ieee.org/document/11673031

## Code Description

This repository includes MATLAB implementations of the proposed near-field beam-training schemes and the benchmark methods considered in the paper.

The implemented methods include:

- Two-phase beam training based on 3D beam diverging
- Three-phase beam training assisted by central ULAs
- Multi-RF-chain beam training for multipath channels
- DFT-based beam training
- Sparse-array-based beam training
- UPA-partitioning-based beam training
- Grid-matching-based beam training

The `method_*.m` files implement the beam-training algorithms.

The `newsim*.m` files contain simulation scripts, while the `pplot*.m` files are used to plot the corresponding simulation results.

## Requirements

- MATLAB

## Usage

Simulation parameters can be configured directly in the corresponding `newsim*.m` files.

This repository contains research code and is mainly intended to illustrate the implementation of the algorithms presented in the paper. Users may adjust the simulation parameters according to their own experimental settings.

## Citation

If you find this code useful, please consider citing our paper:

```bibtex
@article{li2026_3dnearfield,
  author  = {R. Li and Z. Xu and Y.-J. A. Zhang},
  title   = {3D Near-Field Beam Training for Uniform Planar Arrays: Low-Overhead Approaches Leveraging Beam Diverging},
  journal = {IEEE Trans. Wireless Commun.},
  year    = {2026},
  month   = {Aug.}
}
