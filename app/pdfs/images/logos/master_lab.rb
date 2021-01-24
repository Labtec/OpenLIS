# frozen_string_literal: true

module Images
  module Logos
    module MasterLab
    end
  end
end

# MasterLab's logo
def logo_master_lab(rgb: false)
  # Colors
  colors_black = rgb ? '000000' : [0, 0, 0, 100]
  colors_gray = rgb ? '404040' : [0, 0, 0, 75]
  colors_purple = rgb ? '800080' : [0, 100, 0, 50]

  # Master
  fill_color(colors_black)
  save_graphics_state
  transformation_matrix(1, 0, 0, 1, 16.1582, 19.9717)
  fill do
    move_to(0, 0)
    curve_to([-0.187, 6.622], bounds: [[-0.094, 2.036], [-0.21, 4.493]])
    line_to(-0.257, 6.622)
    curve_to([-2.129, 0.585], bounds: [[-0.772, 4.703], [-1.427, 2.574]])
    line_to(-4.446, -6.247)
    line_to(-6.645, -6.247)
    line_to(-8.75, 0.492)
    curve_to([-10.342, 6.622], bounds: [[-9.359, 2.504], [-9.92, 4.656]])
    line_to(-10.388, 6.622)
    curve_to([-10.669, -0.093], bounds: [[-10.458, 4.563], [-10.552, 2.059]])
    line_to(-11.02, -6.434)
    line_to(-13.71, -6.434)
    line_to(-12.658, 9.335)
    line_to(-8.867, 9.335)
    line_to(-6.809, 2.995)
    curve_to([-5.358, -2.48], bounds: [[-6.247, 1.146], [-5.756, -0.725]])
    line_to(-5.288, -2.48)
    curve_to([-3.72, 3.018], bounds: [[-4.867, -0.772], [-4.329, 1.17]])
    line_to(-1.544, 9.335)
    line_to(2.2, 9.335)
    line_to(3.112, -6.434)
    line_to(0.304, -6.434)
    line_to(0, 0)
  end
  restore_graphics_state
  save_graphics_state
  transformation_matrix(1, 0, 0, 1, 28.21, 19.106)
  fill do
    move_to(0, 0)
    curve_to([-3.977, -2.129], bounds: [[-2.036, 0.023], [-3.977, -0.397]])
    curve_to([-2.339, -3.767], bounds: [[-3.977, -3.252], [-3.252, -3.767]])
    curve_to([-0.07, -2.199], bounds: [[-1.169, -3.767], [-0.351, -3.018]])
    curve_to([0, -1.567], bounds: [[0, -1.989], [0, -1.778]])
    line_to(0, 0)
    move_to(2.808, -2.831)
    curve_to([2.995, -5.568], bounds: [[2.808, -3.86], [2.855, -4.866]])
    line_to(0.398, -5.568)
    line_to(0.188, -4.305)
    line_to(0.117, -4.305)
    curve_to([-3.252, -5.826], bounds: [[-0.561, -5.194], [-1.754, -5.826]])
    curve_to([-6.832, -2.433], bounds: [[-5.545, -5.826], [-6.832, -4.165]])
    curve_to([-0.07, 1.872], bounds: [[-6.832, 0.421], [-4.282, 1.895]])
    line_to(-0.07, 2.059)
    curve_to([-2.386, 4.048], bounds: [[-0.07, 2.808], [-0.375, 4.048]])
    curve_to([-5.452, 3.206], bounds: [[-3.509, 4.048], [-4.679, 3.697]])
    line_to(-6.013, 5.077)
    curve_to([-1.895, 6.083], bounds: [[-5.17, 5.592], [-3.697, 6.083]])
    curve_to([2.808, 1.264], bounds: [[1.755, 6.083], [2.808, 3.767]])
    line_to(2.808, -2.831)
  end
  restore_graphics_state
  save_graphics_state
  transformation_matrix(1, 0, 0, 1, 33.9438, 16.2051)
  fill do
    move_to(0, 0)
    curve_to([2.901, -0.842], bounds: [[0.631, -0.398], [1.872, -0.842]])
    curve_to([4.726, 0.444], bounds: [[4.165, -0.842], [4.726, -0.304]])
    curve_to([2.854, 2.105], bounds: [[4.726, 1.216], [4.258, 1.591]])
    curve_to([-0.281, 5.428], bounds: [[0.631, 2.854], [-0.281, 4.071]])
    curve_to([4.024, 8.984], bounds: [[-0.281, 7.44], [1.38, 8.984]])
    curve_to([7.066, 8.306], bounds: [[5.288, 8.984], [6.387, 8.68]])
    line_to(6.481, 6.293)
    curve_to([4.071, 6.949], bounds: [[6.013, 6.574], [5.077, 6.949]])
    curve_to([2.48, 5.732], bounds: [[3.042, 6.949], [2.48, 6.434]])
    curve_to([4.469, 4.141], bounds: [[2.48, 5.007], [3.018, 4.679]])
    curve_to([7.51, 0.678], bounds: [[6.551, 3.416], [7.487, 2.363]])
    curve_to([2.877, -2.901], bounds: [[7.51, -1.404], [5.896, -2.901]])
    curve_to([-0.585, -2.106], bounds: [[1.497, -2.901], [0.257, -2.574]])
    line_to(0, 0)
  end
  restore_graphics_state
  save_graphics_state
  transformation_matrix(1, 0, 0, 1, 47.1172, 27.8564)
  fill do
    move_to(0, 0)
    line_to(0, -2.924)
    line_to(2.738, -2.924)
    line_to(2.738, -5.077)
    line_to(0, -5.077)
    line_to(0, -10.107)
    curve_to([1.474, -12.213], bounds: [[0, -11.511], [0.375, -12.213]])
    curve_to([2.597, -12.096], bounds: [[1.989, -12.213], [2.27, -12.19]])
    line_to(2.644, -14.272)
    curve_to([0.562, -14.576], bounds: [[2.223, -14.436], [1.451, -14.576]])
    curve_to([-1.918, -13.64], bounds: [[-0.515, -14.576], [-1.38, -14.225]])
    curve_to([-2.831, -10.435], bounds: [[-2.55, -12.985], [-2.831, -11.933]])
    line_to(-2.831, -5.077)
    line_to(-4.445, -5.077)
    line_to(-4.445, -2.924)
    line_to(-2.831, -2.924)
    line_to(-2.831, -0.795)
    line_to(0, 0)
  end
  restore_graphics_state
  save_graphics_state
  transformation_matrix(1, 0, 0, 1, 58.9336, 20.4399)
  fill do
    move_to(0, 0)
    curve_to([-2.363, 2.784], bounds: [[0.024, 1.053], [-0.444, 2.784]])
    curve_to([-5.007, 0], bounds: [[-4.141, 2.784], [-4.89, 1.169]])
    line_to(0, 0)
    move_to(-5.007, -2.012)
    curve_to([-1.497, -4.96], bounds: [[-4.937, -4.071], [-3.346, -4.96]])
    curve_to([1.662, -4.446], bounds: [[-0.164, -4.96], [0.772, -4.75]])
    line_to(2.083, -6.411)
    curve_to([-1.895, -7.136], bounds: [[1.1, -6.832], [-0.257, -7.136]])
    curve_to([-7.768, -1.38], bounds: [[-5.592, -7.136], [-7.768, -4.867]])
    curve_to([-2.199, 4.75], bounds: [[-7.768, 1.778], [-5.849, 4.75]])
    curve_to([2.714, -0.795], bounds: [[1.498, 4.75], [2.714, 1.708]])
    curve_to([2.621, -2.012], bounds: [[2.714, -1.334], [2.667, -1.755]])
    line_to(-5.007, -2.012)
  end
  restore_graphics_state
  save_graphics_state
  transformation_matrix(1, 0, 0, 1, 63.9653, 21.2588)
  fill do
    move_to(0, 0)
    curve_to([-0.093, 3.673], bounds: [[0, 1.544], [-0.023, 2.667]])
    line_to(2.387, 3.673)
    line_to(2.503, 1.521)
    line_to(2.574, 1.521)
    curve_to([5.709, 3.931], bounds: [[3.135, 3.112], [4.469, 3.931]])
    curve_to([6.388, 3.86], bounds: [[5.99, 3.931], [6.153, 3.907]])
    line_to(6.388, 1.169)
    curve_to([5.522, 1.24], bounds: [[6.13, 1.217], [5.873, 1.24]])
    curve_to([2.948, -0.936], bounds: [[4.165, 1.24], [3.206, 0.375]])
    curve_to([2.878, -1.802], bounds: [[2.901, -1.193], [2.878, -1.498]])
    line_to(2.878, -7.721)
    line_to(0, -7.721)
    line_to(0, 0)
  end
  restore_graphics_state
  # Lab
  fill_color(colors_gray)
  save_graphics_state
  transformation_matrix(1, 0, 0, 1, 72.4126, 29.3071)
  fill do
    move_to(0, 0)
    line_to(2.877, 0)
    line_to(2.877, -13.36)
    line_to(9.359, -13.36)
    line_to(9.359, -15.77)
    line_to(0, -15.77)
    line_to(0, 0)
  end
  restore_graphics_state
  save_graphics_state
  transformation_matrix(1, 0, 0, 1, 89.8682, 19.106)
  fill do
    move_to(0, 0)
    curve_to([-3.978, -2.129], bounds: [[-2.036, 0.023], [-3.978, -0.397]])
    curve_to([-2.34, -3.767], bounds: [[-3.978, -3.252], [-3.252, -3.767]])
    curve_to([-0.07, -2.199], bounds: [[-1.17, -3.767], [-0.351, -3.018]])
    curve_to([0, -1.567], bounds: [[0, -1.989], [0, -1.778]])
    line_to(0, 0)
    move_to(2.808, -2.831)
    curve_to([2.995, -5.568], bounds: [[2.808, -3.86], [2.854, -4.866]])
    line_to(0.397, -5.568)
    line_to(0.187, -4.305)
    line_to(0.117, -4.305)
    curve_to([-3.252, -5.826], bounds: [[-0.562, -5.194], [-1.755, -5.826]])
    curve_to([-6.832, -2.433], bounds: [[-5.545, -5.826], [-6.832, -4.165]])
    curve_to([-0.07, 1.872], bounds: [[-6.832, 0.421], [-4.282, 1.895]])
    line_to(-0.07, 2.059)
    curve_to([-2.386, 4.048], bounds: [[-0.07, 2.808], [-0.375, 4.048]])
    curve_to([-5.452, 3.206], bounds: [[-3.51, 4.048], [-4.68, 3.697]])
    line_to(-6.013, 5.077)
    curve_to([-1.895, 6.083], bounds: [[-5.171, 5.592], [-3.697, 6.083]])
    curve_to([2.808, 1.264], bounds: [[1.755, 6.083], [2.808, 3.767]])
    line_to(2.808, -2.831)
  end
  restore_graphics_state
  save_graphics_state
  transformation_matrix(1, 0, 0, 1, 98.5967, 18.2402)
  fill do
    move_to(0, 0)
    curve_to([0.07, -0.678], bounds: [[0, -0.234], [0.023, -0.468]])
    curve_to([2.62, -2.69], bounds: [[0.374, -1.848], [1.38, -2.69]])
    curve_to([5.521, 1.053], bounds: [[4.421, -2.69], [5.521, -1.263]])
    curve_to([2.644, 4.703], bounds: [[5.521, 3.065], [4.562, 4.703]])
    curve_to([0.093, 2.597], bounds: [[1.474, 4.703], [0.397, 3.861]])
    curve_to([0, 1.849], bounds: [[0.046, 2.387], [0, 2.129]])
    line_to(0, 0)
    move_to(-2.878, 11.909)
    line_to(0, 11.909)
    line_to(0, 5.124)
    line_to(0.046, 5.124)
    curve_to([3.697, 6.949], bounds: [[0.749, 6.224], [1.989, 6.949]])
    curve_to([8.446, 1.17], bounds: [[6.481, 6.949], [8.47, 4.633]])
    curve_to([3.275, -4.96], bounds: [[8.446, -2.924], [5.849, -4.96]])
    curve_to([-0.328, -2.995], bounds: [[1.801, -4.96], [0.491, -4.398]])
    line_to(-0.375, -2.995)
    line_to(-0.515, -4.703)
    line_to(-2.972, -4.703)
    curve_to([-2.878, -1.498], bounds: [[-2.925, -3.931], [-2.878, -2.667]])
    line_to(-2.878, 11.909)
  end
  restore_graphics_state
  # Laboratorio
  save_graphics_state
  transformation_matrix(1, 0, 0, 1, 25.2676, 9.0586)
  fill do
    move_to(0, 0)
    line_to(0.801, 0)
    line_to(0.801, -5.472)
    line_to(3.423, -5.472)
    line_to(3.423, -6.137)
    line_to(0, -6.137)
    line_to(0, 0)
  end
  restore_graphics_state
  save_graphics_state
  transformation_matrix(1, 0, 0, 1, 31.8657, 5.1709)
  fill do
    move_to(0, 0)
    curve_to([-1.866, -0.993], bounds: [[-0.874, 0.018], [-1.866, -0.137]])
    curve_to([-1.12, -1.757], bounds: [[-1.866, -1.521], [-1.52, -1.757]])
    curve_to([-0.036, -1.02], bounds: [[-0.537, -1.757], [-0.164, -1.393]])
    curve_to([0, -0.765], bounds: [[-0.009, -0.929], [0, -0.838]])
    line_to(0, 0)
    move_to(0.774, -1.193)
    curve_to([0.838, -2.249], bounds: [[0.774, -1.575], [0.792, -1.949]])
    line_to(0.119, -2.249)
    line_to(0.055, -1.694)
    line_to(0.028, -1.694)
    curve_to([-1.32, -2.35], bounds: [[-0.218, -2.04], [-0.692, -2.35]])
    curve_to([-2.667, -1.083], bounds: [[-2.212, -2.35], [-2.667, -1.721]])
    curve_to([-0.018, 0.555], bounds: [[-2.667, -0.019], [-1.72, 0.564]])
    line_to(-0.018, 0.646)
    curve_to([-1.02, 1.657], bounds: [[-0.018, 1.001], [-0.118, 1.666]])
    curve_to([-2.176, 1.329], bounds: [[-1.438, 1.657], [-1.866, 1.539]])
    line_to(-2.358, 1.866)
    curve_to([-0.901, 2.249], bounds: [[-1.994, 2.094], [-1.457, 2.249]])
    curve_to([0.774, 0.455], bounds: [[0.446, 2.249], [0.774, 1.329]])
    line_to(0.774, -1.193)
  end
  restore_graphics_state
  save_graphics_state
  transformation_matrix(1, 0, 0, 1, 34.7227, 4.688)
  fill do
    move_to(0, 0)
    curve_to([0.037, -0.292], bounds: [[0, -0.1], [0.009, -0.2]])
    curve_to([1.238, -1.229], bounds: [[0.182, -0.847], [0.655, -1.229]])
    curve_to([2.577, 0.464], bounds: [[2.085, -1.229], [2.577, -0.546]])
    curve_to([1.256, 2.104], bounds: [[2.577, 1.348], [2.121, 2.104]])
    curve_to([0.045, 1.12], bounds: [[0.719, 2.104], [0.209, 1.721]])
    curve_to([0, 0.783], bounds: [[0.018, 1.02], [0, 0.911]])
    line_to(0, 0)
    move_to(-0.792, 4.698)
    line_to(0, 4.698)
    line_to(0, 1.93)
    line_to(0.018, 1.93)
    curve_to([1.521, 2.732], bounds: [[0.3, 2.422], [0.81, 2.732]])
    curve_to([3.387, 0.492], bounds: [[2.622, 2.732], [3.387, 1.821]])
    curve_to([1.402, -1.867], bounds: [[3.387, -1.083], [2.385, -1.867]])
    curve_to([-0.082, -1.047], bounds: [[0.765, -1.867], [0.255, -1.621]])
    line_to(-0.101, -1.047)
    line_to(-0.146, -1.766)
    line_to(-0.829, -1.766)
    curve_to([-0.792, -0.628], bounds: [[-0.811, -1.466], [-0.792, -1.02]])
    line_to(-0.792, 4.698)
  end
  restore_graphics_state
  save_graphics_state
  transformation_matrix(1, 0, 0, 1, 39.6089, 5.1162)
  fill do
    move_to(0, 0)
    curve_to([1.329, -1.693], bounds: [[0, -0.965], [0.546, -1.693]])
    curve_to([2.667, 0.018], bounds: [[2.094, -1.693], [2.667, -0.975]])
    curve_to([1.348, 1.703], bounds: [[2.667, 0.765], [2.294, 1.703]])
    curve_to([0, 0], bounds: [[0.41, 1.703], [0, 0.828]])
    move_to(3.487, 0.045)
    curve_to([1.293, -2.295], bounds: [[3.487, -1.584], [2.349, -2.295]])
    curve_to([-0.819, -0.027], bounds: [[0.109, -2.295], [-0.819, -1.42]])
    curve_to([1.366, 2.304], bounds: [[-0.819, 1.438], [0.155, 2.304]])
    curve_to([3.487, 0.045], bounds: [[2.631, 2.304], [3.487, 1.384]])
  end
  restore_graphics_state
  save_graphics_state
  transformation_matrix(1, 0, 0, 1, 44.104, 5.9536)
  fill do
    move_to(0, 0)
    curve_to([-0.037, 1.375], bounds: [[0, 0.519], [-0.009, 0.965]])
    line_to(0.665, 1.375)
    line_to(0.701, 0.501)
    line_to(0.729, 0.501)
    curve_to([1.958, 1.466], bounds: [[0.929, 1.093], [1.42, 1.466]])
    curve_to([2.176, 1.448], bounds: [[2.04, 1.466], [2.104, 1.457]])
    line_to(2.176, 0.692)
    curve_to([1.903, 0.71], bounds: [[2.094, 0.71], [2.012, 0.71]])
    curve_to([0.829, -0.309], bounds: [[1.338, 0.71], [0.938, 0.292]])
    curve_to([0.801, -0.683], bounds: [[0.811, -0.419], [0.801, -0.555]])
    line_to(0.801, -3.032)
    line_to(0, -3.032)
    line_to(0, 0)
  end
  restore_graphics_state
  save_graphics_state
  transformation_matrix(1, 0, 0, 1, 49.356, 5.1709)
  fill do
    move_to(0, 0)
    curve_to([-1.866, -0.993], bounds: [[-0.874, 0.018], [-1.866, -0.137]])
    curve_to([-1.12, -1.757], bounds: [[-1.866, -1.521], [-1.52, -1.757]])
    curve_to([-0.036, -1.02], bounds: [[-0.537, -1.757], [-0.164, -1.393]])
    curve_to([0, -0.765], bounds: [[-0.009, -0.929], [0, -0.838]])
    line_to(0, 0)
    move_to(0.774, -1.193)
    curve_to([0.838, -2.249], bounds: [[0.774, -1.575], [0.792, -1.949]])
    line_to(0.119, -2.249)
    line_to(0.055, -1.694)
    line_to(0.028, -1.694)
    curve_to([-1.32, -2.35], bounds: [[-0.218, -2.04], [-0.692, -2.35]])
    curve_to([-2.667, -1.083], bounds: [[-2.212, -2.35], [-2.667, -1.721]])
    curve_to([-0.018, 0.555], bounds: [[-2.667, -0.019], [-1.72, 0.564]])
    line_to(-0.018, 0.646)
    curve_to([-1.019, 1.657], bounds: [[-0.018, 1.001], [-0.118, 1.666]])
    curve_to([-2.176, 1.329], bounds: [[-1.438, 1.657], [-1.866, 1.539]])
    line_to(-2.358, 1.866)
    curve_to([-0.901, 2.249], bounds: [[-1.994, 2.094], [-1.457, 2.249]])
    curve_to([0.774, 0.455], bounds: [[0.446, 2.249], [0.774, 1.329]])
    line_to(0.774, -1.193)
  end
  restore_graphics_state
  save_graphics_state
  transformation_matrix(1, 0, 0, 1, 52.3496, 8.3848)
  fill do
    move_to(0, 0)
    line_to(0, -1.056)
    line_to(1.147, -1.056)
    line_to(1.147, -1.666)
    line_to(0, -1.666)
    line_to(0, -4.042)
    curve_to([0.601, -4.898], bounds: [[0, -4.589], [0.155, -4.898]])
    curve_to([1.065, -4.844], bounds: [[0.819, -4.898], [0.947, -4.88]])
    line_to(1.102, -5.454)
    curve_to([0.392, -5.563], bounds: [[0.947, -5.508], [0.701, -5.563]])
    curve_to([-0.474, -5.226], bounds: [[0.018, -5.563], [-0.282, -5.436]])
    curve_to([-0.783, -4.07], bounds: [[-0.692, -4.98], [-0.783, -4.589]])
    line_to(-0.783, -1.666)
    line_to(-1.466, -1.666)
    line_to(-1.466, -1.056)
    line_to(-0.783, -1.056)
    line_to(-0.783, -0.237)
    line_to(0, 0)
  end
  restore_graphics_state
  save_graphics_state
  transformation_matrix(1, 0, 0, 1, 54.8423, 5.1162)
  fill do
    move_to(0, 0)
    curve_to([1.329, -1.693], bounds: [[0, -0.965], [0.546, -1.693]])
    curve_to([2.668, 0.018], bounds: [[2.094, -1.693], [2.668, -0.975]])
    curve_to([1.348, 1.703], bounds: [[2.668, 0.765], [2.294, 1.703]])
    curve_to([0, 0], bounds: [[0.41, 1.703], [0, 0.828]])
    move_to(3.487, 0.045)
    curve_to([1.293, -2.295], bounds: [[3.487, -1.584], [2.349, -2.295]])
    curve_to([-0.819, -0.027], bounds: [[0.109, -2.295], [-0.819, -1.42]])
    curve_to([1.366, 2.304], bounds: [[-0.819, 1.438], [0.155, 2.304]])
    curve_to([3.487, 0.045], bounds: [[2.631, 2.304], [3.487, 1.384]])
  end
  restore_graphics_state
  save_graphics_state
  transformation_matrix(1, 0, 0, 1, 59.3374, 5.9536)
  fill do
    move_to(0, 0)
    curve_to([-0.037, 1.375], bounds: [[0, 0.519], [-0.009, 0.965]])
    line_to(0.665, 1.375)
    line_to(0.701, 0.501)
    line_to(0.729, 0.501)
    curve_to([1.958, 1.466], bounds: [[0.929, 1.093], [1.42, 1.466]])
    curve_to([2.176, 1.448], bounds: [[2.04, 1.466], [2.104, 1.457]])
    line_to(2.176, 0.692)
    curve_to([1.903, 0.71], bounds: [[2.094, 0.71], [2.012, 0.71]])
    curve_to([0.829, -0.309], bounds: [[1.338, 0.71], [0.938, 0.292]])
    curve_to([0.801, -0.683], bounds: [[0.811, -0.419], [0.801, -0.555]])
    line_to(0.801, -3.032)
    line_to(0, -3.032)
    line_to(0, 0)
  end
  restore_graphics_state
  fill do
    rectangle([62.35, 2.922], 0.802, -4.407)
    move_to(63.242, 8.567)
    curve_to([62.732, 8.075], bounds: [[63.242, 8.294], [63.051, 8.075]])
    curve_to([62.25, 8.567], bounds: [[62.441, 8.075], [62.25, 8.294]])
    curve_to([62.75, 9.067], bounds: [[62.25, 8.84], [62.45, 9.067]])
    curve_to([63.242, 8.567], bounds: [[63.042, 9.067], [63.242, 8.849]])
  end
  save_graphics_state
  transformation_matrix(1, 0, 0, 1, 64.98, 5.1162)
  fill do
    move_to(0, 0)
    curve_to([1.329, -1.693], bounds: [[0, -0.965], [0.546, -1.693]])
    curve_to([2.667, 0.018], bounds: [[2.094, -1.693], [2.667, -0.975]])
    curve_to([1.348, 1.703], bounds: [[2.667, 0.765], [2.294, 1.703]])
    curve_to([0, 0], bounds: [[0.41, 1.703], [0, 0.828]])
    move_to(3.487, 0.045)
    curve_to([1.293, -2.295], bounds: [[3.487, -1.584], [2.349, -2.295]])
    curve_to([-0.819, -0.027], bounds: [[0.109, -2.295], [-0.819, -1.42]])
    curve_to([1.366, 2.304], bounds: [[-0.819, 1.438], [0.155, 2.304]])
    curve_to([3.487, 0.045], bounds: [[2.631, 2.304], [3.487, 1.384]])
  end
  restore_graphics_state
  # Clínico
  save_graphics_state
  transformation_matrix(1, 0, 0, 1, 75.7104, 3.1128)
  fill do
    move_to(0, 0)
    curve_to([-1.62, -0.292], bounds: [[-0.282, -0.146], [-0.874, -0.292]])
    curve_to([-4.643, 2.823], bounds: [[-3.351, -0.292], [-4.643, 0.801]])
    curve_to([-1.438, 6.046], bounds: [[-4.643, 4.753], [-3.341, 6.046]])
    curve_to([0.019, 5.772], bounds: [[-0.683, 6.046], [-0.191, 5.882]])
    line_to(-0.182, 5.126)
    curve_to([-1.411, 5.381], bounds: [[-0.473, 5.272], [-0.901, 5.381]])
    curve_to([-3.806, 2.85], bounds: [[-2.85, 5.381], [-3.806, 4.461]])
    curve_to([-1.457, 0.382], bounds: [[-3.806, 1.338], [-2.94, 0.382]])
    curve_to([-0.154, 0.638], bounds: [[-0.965, 0.382], [-0.473, 0.483]])
    line_to(0, 0)
  end
  restore_graphics_state
  fill do
    rectangle([76.682, 2.922], 0.802, -6.464)
  end
  fill do
    rectangle([78.829, 2.922], 0.802, -4.407)
    move_to(80.459, 9.231)
    line_to(79.348, 7.93)
    line_to(78.784, 7.93)
    line_to(79.585, 9.231)
    line_to(80.459, 9.231)
  end
  save_graphics_state
  transformation_matrix(1, 0, 0, 1, 80.9585, 6.1357)
  fill do
    move_to(0, 0)
    curve_to([-0.037, 1.193], bounds: [[0, 0.464], [-0.009, 0.829]])
    line_to(0.674, 1.193)
    line_to(0.719, 0.464)
    line_to(0.738, 0.464)
    curve_to([2.194, 1.284], bounds: [[0.956, 0.874], [1.466, 1.284]])
    curve_to([3.751, -0.592], bounds: [[2.805, 1.284], [3.751, 0.919]])
    line_to(3.751, -3.214)
    line_to(2.95, -3.214)
    line_to(2.95, -0.674)
    curve_to([1.93, 0.628], bounds: [[2.95, 0.036], [2.686, 0.628]])
    curve_to([0.856, -0.191], bounds: [[1.412, 0.628], [1.002, 0.255]])
    curve_to([0.801, -0.564], bounds: [[0.819, -0.291], [0.801, -0.428]])
    line_to(0.801, -3.214)
    line_to(0, -3.214)
    line_to(0, 0)
  end
  restore_graphics_state
  fill do
    rectangle([86.009, 2.922], 0.801, -4.407)
    move_to(86.901, 8.567)
    curve_to([86.392, 8.075], bounds: [[86.901, 8.294], [86.71, 8.075]])
    curve_to([85.909, 8.567], bounds: [[86.1, 8.075], [85.909, 8.294]])
    curve_to([86.41, 9.067], bounds: [[85.909, 8.84], [86.109, 9.067]])
    curve_to([86.901, 8.567], bounds: [[86.701, 9.067], [86.901, 8.849]])
  end
  save_graphics_state
  transformation_matrix(1, 0, 0, 1, 91.2798, 3.0767)
  fill do
    move_to(0, 0)
    curve_to([-1.266, -0.255], bounds: [[-0.209, -0.1], [-0.674, -0.255]])
    curve_to([-3.46, 1.994], bounds: [[-2.595, -0.255], [-3.46, 0.646]])
    curve_to([-1.093, 4.343], bounds: [[-3.46, 3.351], [-2.531, 4.343]])
    curve_to([0.018, 4.106], bounds: [[-0.619, 4.343], [-0.201, 4.225]])
    line_to(-0.164, 3.496)
    curve_to([-1.093, 3.706], bounds: [[-0.355, 3.596], [-0.656, 3.706]])
    curve_to([-2.65, 2.04], bounds: [[-2.103, 3.706], [-2.65, 2.95]])
    curve_to([-1.12, 0.391], bounds: [[-2.65, 1.02], [-1.994, 0.391]])
    curve_to([-0.137, 0.601], bounds: [[-0.665, 0.391], [-0.364, 0.5]])
    line_to(0, 0)
  end
  restore_graphics_state
  save_graphics_state
  transformation_matrix(1, 0, 0, 1, 92.6616, 5.1162)
  fill do
    move_to(0, 0)
    curve_to([1.329, -1.693], bounds: [[0, -0.965], [0.546, -1.693]])
    curve_to([2.667, 0.018], bounds: [[2.094, -1.693], [2.667, -0.975]])
    curve_to([1.348, 1.703], bounds: [[2.667, 0.765], [2.294, 1.703]])
    curve_to([0, 0], bounds: [[0.41, 1.703], [0, 0.828]])
    move_to(3.487, 0.045)
    curve_to([1.293, -2.295], bounds: [[3.487, -1.584], [2.349, -2.295]])
    curve_to([-0.82, -0.027], bounds: [[0.109, -2.295], [-0.82, -1.42]])
    curve_to([1.366, 2.304], bounds: [[-0.82, 1.438], [0.155, 2.304]])
    curve_to([3.487, 0.045], bounds: [[2.631, 2.304], [3.487, 1.384]])
  end
  restore_graphics_state
  # Especializado
  save_graphics_state
  transformation_matrix(1, 0, 0, 1, 102.2817, 5.7988)
  fill do
    move_to(0, 0)
    line_to(-2.376, 0)
    line_to(-2.376, -2.212)
    line_to(0.282, -2.212)
    line_to(0.282, -2.877)
    line_to(-3.178, -2.877)
    line_to(-3.178, 3.26)
    line_to(0.145, 3.26)
    line_to(0.145, 2.595)
    line_to(-2.376, 2.595)
    line_to(-2.376, 0.656)
    line_to(0, 0.656)
    line_to(0, 0)
  end
  restore_graphics_state
  save_graphics_state
  transformation_matrix(1, 0, 0, 1, 103.4536, 3.7319)
  fill do
    move_to(0, 0)
    curve_to([1.065, -0.309], bounds: [[0.246, -0.146], [0.665, -0.309]])
    curve_to([1.912, 0.346], bounds: [[1.639, -0.309], [1.912, -0.027]])
    curve_to([1.102, 1.147], bounds: [[1.912, 0.729], [1.684, 0.929]])
    curve_to([-0.073, 2.395], bounds: [[0.3, 1.439], [-0.073, 1.867]])
    curve_to([1.447, 3.688], bounds: [[-0.073, 3.105], [0.509, 3.688]])
    curve_to([2.521, 3.415], bounds: [[1.894, 3.688], [2.285, 3.569]])
    line_to(2.331, 2.832)
    curve_to([1.429, 3.096], bounds: [[2.158, 2.941], [1.839, 3.096]])
    curve_to([0.701, 2.495], bounds: [[0.956, 3.096], [0.701, 2.823]])
    curve_to([1.529, 1.739], bounds: [[0.701, 2.131], [0.956, 1.967]])
    curve_to([2.686, 0.419], bounds: [[2.285, 1.457], [2.686, 1.075]])
    curve_to([1.047, -0.911], bounds: [[2.686, -0.364], [2.076, -0.911]])
    curve_to([-0.191, -0.601], bounds: [[0.564, -0.911], [0.118, -0.783]])
    line_to(0, 0)
  end
  restore_graphics_state
  save_graphics_state
  transformation_matrix(1, 0, 0, 1, 107.959, 4.7153)
  fill do
    move_to(0, 0)
    curve_to([0.036, -0.328], bounds: [[0, -0.118], [0.009, -0.228]])
    curve_to([1.238, -1.266], bounds: [[0.182, -0.883], [0.665, -1.266]])
    curve_to([2.577, 0.437], bounds: [[2.085, -1.266], [2.577, -0.574]])
    curve_to([1.266, 2.067], bounds: [[2.577, 1.311], [2.112, 2.067]])
    curve_to([0.055, 1.083], bounds: [[0.719, 2.067], [0.201, 1.685]])
    curve_to([0, 0.765], bounds: [[0.027, 0.983], [0, 0.865]])
    line_to(0, 0)
    move_to(-0.792, 1.175)
    curve_to([-0.829, 2.613], bounds: [[-0.792, 1.739], [-0.811, 2.194]])
    line_to(-0.118, 2.613)
    line_to(-0.073, 1.857)
    line_to(-0.055, 1.857)
    curve_to([1.511, 2.705], bounds: [[0.264, 2.395], [0.792, 2.705]])
    curve_to([3.387, 0.474], bounds: [[2.586, 2.705], [3.387, 1.803]])
    curve_to([1.375, -1.894], bounds: [[3.387, -1.11], [2.413, -1.894]])
    curve_to([0.019, -1.202], bounds: [[0.792, -1.894], [0.282, -1.639]])
    line_to(0, -1.202)
    line_to(0, -3.596)
    line_to(-0.792, -3.596)
    line_to(-0.792, 1.175)
  end
  restore_graphics_state
  save_graphics_state
  transformation_matrix(1, 0, 0, 1, 115.1401, 5.5532)
  fill do
    move_to(0, 0)
    curve_to([-1.111, 1.292], bounds: [[0.009, 0.501], [-0.209, 1.292]])
    curve_to([-2.34, 0], bounds: [[-1.93, 1.292], [-2.276, 0.555]])
    line_to(0, 0)
    move_to(-2.349, -0.574)
    curve_to([-0.838, -2.104], bounds: [[-2.331, -1.657], [-1.648, -2.104]])
    curve_to([0.382, -1.876], bounds: [[-0.264, -2.104], [0.091, -2.003]])
    line_to(0.528, -2.449)
    curve_to([-0.947, -2.732], bounds: [[0.246, -2.577], [-0.247, -2.732]])
    curve_to([-3.114, -0.501], bounds: [[-2.304, -2.732], [-3.114, -1.83]])
    curve_to([-1.047, 1.867], bounds: [[-3.114, 0.828], [-2.331, 1.867]])
    curve_to([0.774, -0.2], bounds: [[0.4, 1.867], [0.774, 0.61]])
    curve_to([0.747, -0.574], bounds: [[0.774, -0.364], [0.765, -0.483]])
    line_to(-2.349, -0.574)
  end
  restore_graphics_state
  save_graphics_state
  transformation_matrix(1, 0, 0, 1, 120.0449, 3.0767)
  fill do
    move_to(0, 0)
    curve_to([-1.266, -0.255], bounds: [[-0.209, -0.1], [-0.674, -0.255]])
    curve_to([-3.46, 1.994], bounds: [[-2.595, -0.255], [-3.46, 0.646]])
    curve_to([-1.093, 4.343], bounds: [[-3.46, 3.351], [-2.531, 4.343]])
    curve_to([0.018, 4.106], bounds: [[-0.62, 4.343], [-0.201, 4.225]])
    line_to(-0.164, 3.496)
    curve_to([-1.093, 3.706], bounds: [[-0.355, 3.596], [-0.656, 3.706]])
    curve_to([-2.649, 2.04], bounds: [[-2.104, 3.706], [-2.649, 2.95]])
    curve_to([-1.121, 0.391], bounds: [[-2.649, 1.02], [-1.995, 0.391]])
    curve_to([-0.137, 0.601], bounds: [[-0.665, 0.391], [-0.364, 0.5]])
    line_to(0, 0)
  end
  restore_graphics_state
  fill do
    rectangle([120.98, 2.922], 0.801, -4.407)
    move_to(121.874, 8.567)
    curve_to([121.363, 8.075], bounds: [[121.874, 8.294], [121.682, 8.075]])
    curve_to([120.88, 8.567], bounds: [[121.072, 8.075], [120.88, 8.294]])
    curve_to([121.381, 9.067], bounds: [[120.88, 8.84], [121.081, 9.067]])
    curve_to([121.874, 8.567], bounds: [[121.673, 9.067], [121.874, 8.849]])
  end
  save_graphics_state
  transformation_matrix(1, 0, 0, 1, 125.4316, 5.1709)
  fill do
    move_to(0, 0)
    curve_to([-1.866, -0.993], bounds: [[-0.873, 0.018], [-1.866, -0.137]])
    curve_to([-1.12, -1.757], bounds: [[-1.866, -1.521], [-1.521, -1.757]])
    curve_to([-0.037, -1.02], bounds: [[-0.537, -1.757], [-0.164, -1.393]])
    curve_to([0, -0.765], bounds: [[-0.009, -0.929], [0, -0.838]])
    line_to(0, 0)
    move_to(0.774, -1.193)
    curve_to([0.838, -2.249], bounds: [[0.774, -1.575], [0.792, -1.949]])
    line_to(0.118, -2.249)
    line_to(0.055, -1.694)
    line_to(0.028, -1.694)
    curve_to([-1.32, -2.35], bounds: [[-0.218, -2.04], [-0.692, -2.35]])
    curve_to([-2.667, -1.083], bounds: [[-2.212, -2.35], [-2.667, -1.721]])
    curve_to([-0.018, 0.555], bounds: [[-2.667, -0.019], [-1.72, 0.564]])
    line_to(-0.018, 0.646)
    curve_to([-1.019, 1.657], bounds: [[-0.018, 1.001], [-0.118, 1.666]])
    curve_to([-2.176, 1.329], bounds: [[-1.438, 1.657], [-1.866, 1.539]])
    line_to(-2.357, 1.866)
    curve_to([-0.901, 2.249], bounds: [[-1.994, 2.094], [-1.456, 2.249]])
    curve_to([0.774, 0.455], bounds: [[0.447, 2.249], [0.774, 1.329]])
    line_to(0.774, -1.193)
  end
  restore_graphics_state
  fill do
    rectangle([127.496, 2.922], 0.801, -6.464)
  end
  fill do
    rectangle([129.644, 2.922], 0.801, -4.407)
    move_to(130.537, 8.567)
    curve_to([130.026, 8.075], bounds: [[130.537, 8.294], [130.345, 8.075]])
    curve_to([129.544, 8.567], bounds: [[129.735, 8.075], [129.544, 8.294]])
    curve_to([130.044, 9.067], bounds: [[129.544, 8.84], [129.745, 9.067]])
    curve_to([130.537, 8.567], bounds: [[130.336, 9.067], [130.537, 8.849]])
  end
  save_graphics_state
  transformation_matrix(1, 0, 0, 1, 131.2729, 3.3862)
  fill do
    move_to(0, 0)
    line_to(1.984, 2.595)
    curve_to([2.567, 3.287], bounds: [[2.185, 2.841], [2.368, 3.05]])
    line_to(2.567, 3.305)
    line_to(0.182, 3.305)
    line_to(0.182, 3.942)
    line_to(3.533, 3.942)
    line_to(3.533, 3.441)
    line_to(1.565, 0.883)
    curve_to([1.001, 0.191], bounds: [[1.375, 0.637], [1.202, 0.41]])
    line_to(1.001, 0.173)
    line_to(3.569, 0.173)
    line_to(3.569, -0.464)
    line_to(0, -0.464)
    line_to(0, 0)
  end
  restore_graphics_state
  save_graphics_state
  transformation_matrix(1, 0, 0, 1, 137.9902, 5.1709)
  fill do
    move_to(0, 0)
    curve_to([-1.866, -0.993], bounds: [[-0.874, 0.018], [-1.866, -0.137]])
    curve_to([-1.12, -1.757], bounds: [[-1.866, -1.521], [-1.521, -1.757]])
    curve_to([-0.037, -1.02], bounds: [[-0.537, -1.757], [-0.164, -1.393]])
    curve_to([0, -0.765], bounds: [[-0.009, -0.929], [0, -0.838]])
    line_to(0, 0)
    move_to(0.774, -1.193)
    curve_to([0.838, -2.249], bounds: [[0.774, -1.575], [0.792, -1.949]])
    line_to(0.118, -2.249)
    line_to(0.054, -1.694)
    line_to(0.028, -1.694)
    curve_to([-1.32, -2.35], bounds: [[-0.219, -2.04], [-0.692, -2.35]])
    curve_to([-2.667, -1.083], bounds: [[-2.213, -2.35], [-2.667, -1.721]])
    curve_to([-0.018, 0.555], bounds: [[-2.667, -0.019], [-1.72, 0.564]])
    line_to(-0.018, 0.646)
    curve_to([-1.02, 1.657], bounds: [[-0.018, 1.001], [-0.118, 1.666]])
    curve_to([-2.176, 1.329], bounds: [[-1.438, 1.657], [-1.866, 1.539]])
    line_to(-2.358, 1.866)
    curve_to([-0.901, 2.249], bounds: [[-1.995, 2.094], [-1.457, 2.249]])
    curve_to([0.774, 0.455], bounds: [[0.447, 2.249], [0.774, 1.329]])
    line_to(0.774, -1.193)
  end
  restore_graphics_state
  save_graphics_state
  transformation_matrix(1, 0, 0, 1, 143.0591, 5.5347)
  fill do
    move_to(0, 0)
    curve_to([-0.037, 0.337], bounds: [[0, 0.101], [-0.009, 0.237]])
    curve_to([-1.192, 1.257], bounds: [[-0.155, 0.838], [-0.591, 1.257]])
    curve_to([-2.512, -0.437], bounds: [[-2.021, 1.257], [-2.512, 0.528]])
    curve_to([-1.211, -2.067], bounds: [[-2.512, -1.329], [-2.066, -2.067]])
    curve_to([-0.037, -1.111], bounds: [[-0.674, -2.067], [-0.181, -1.702]])
    curve_to([0, -0.765], bounds: [[-0.009, -1.001], [0, -0.892]])
    line_to(0, 0)
    move_to(0.792, 3.852)
    line_to(0.792, -1.475)
    curve_to([0.829, -2.613], bounds: [[0.792, -1.866], [0.81, -2.313]])
    line_to(0.118, -2.613)
    line_to(0.083, -1.848)
    line_to(0.055, -1.848)
    curve_to([-1.429, -2.713], bounds: [[-0.181, -2.34], [-0.709, -2.713]])
    curve_to([-3.323, -0.473], bounds: [[-2.495, -2.713], [-3.323, -1.812]])
    curve_to([-1.347, 1.885], bounds: [[-3.333, 0.993], [-2.413, 1.885]])
    curve_to([-0.018, 1.22], bounds: [[-0.665, 1.885], [-0.218, 1.566]])
    line_to(0, 1.22)
    line_to(0, 3.852)
    line_to(0.792, 3.852)
  end
  restore_graphics_state
  save_graphics_state
  transformation_matrix(1, 0, 0, 1, 145.687, 5.1162)
  fill do
    move_to(0, 0)
    curve_to([1.329, -1.693], bounds: [[0, -0.965], [0.548, -1.693]])
    curve_to([2.669, 0.018], bounds: [[2.095, -1.693], [2.669, -0.975]])
    curve_to([1.349, 1.703], bounds: [[2.669, 0.765], [2.296, 1.703]])
    curve_to([0, 0], bounds: [[0.41, 1.703], [0, 0.828]])
    move_to(3.487, 0.045)
    curve_to([1.294, -2.295], bounds: [[3.487, -1.584], [2.351, -2.295]])
    curve_to([-0.819, -0.027], bounds: [[0.109, -2.295], [-0.819, -1.42]])
    curve_to([1.366, 2.304], bounds: [[-0.819, 1.438], [0.155, 2.304]])
    curve_to([3.487, 0.045], bounds: [[2.632, 2.304], [3.487, 1.384]])
  end
  restore_graphics_state
  # Bottom logo
  fill_color(colors_purple)
  save_graphics_state
  transformation_matrix(1, 0, 0, 1, 109.2207, 14.9907)
  fill do
    move_to(0, 0)
    curve_to([0.057, -0.197], bounds: [[0, -0.134], [0.023, -0.189]])
    curve_to([0.41, 0.302], bounds: [[0.16, -0.217], [0.37, 0.204]])
    curve_to([2.275, 3.029], bounds: [[0.837, 1.357], [1.489, 2.249]])
    curve_to([9.806, 7.551], bounds: [[4.335, 5.073], [7.338, 6.32]])
    curve_to([16.896, 14.738], bounds: [[12.527, 8.908], [16.896, 11.177]])
    curve_to([15.726, 18.903], bounds: [[16.896, 16.237], [16.642, 17.68]])
    curve_to([13.256, 14.939], bounds: [[15.726, 17.187], [14.416, 16.019]])
    curve_to([10.052, 12.794], bounds: [[12.319, 14.067], [11.161, 13.417]])
    curve_to([6.074, 10.714], bounds: [[8.747, 12.062], [7.409, 11.389]])
    curve_to([2.398, 8.569], bounds: [[4.808, 10.074], [3.508, 9.465]])
    curve_to([0.153, 5.796], bounds: [[1.487, 7.833], [0.602, 6.897]])
    curve_to([0, 4.279], bounds: [[-0.049, 5.302], [0, 4.803]])
    line_to(0, 0)
  end
  restore_graphics_state
  # Middle logo
  fill_color(colors_gray)
  save_graphics_state
  transformation_matrix(1, 0, 0, 1, 109.6304, 28.1621)
  fill do
    move_to(0, 0)
    curve_to([-0.353, -0.498], bounds: [[-0.04, -0.098], [-0.25, -0.519]])
    curve_to([1.123, -1.803], bounds: [[-0.307, -0.93], [0.821, -1.604]])
    curve_to([2.42, -2.563], bounds: [[1.542, -2.08], [1.978, -2.329]])
    curve_to([3.582, -3.085], bounds: [[2.636, -2.677], [3.369, -3.188]])
    curve_to([7.734, -0.914], bounds: [[4.99, -2.404], [6.327, -1.592]])
    curve_to([1.865, 2.727], bounds: [[5.799, -0.007], [2.919, 0.646]])
    curve_to([0, 0], bounds: [[1.08, 1.948], [0.427, 1.056]])
  end
  restore_graphics_state
  # Top logo
  fill_color(colors_purple)
  save_graphics_state
  transformation_matrix(1, 0, 0, 1, 109.2207, 27.8608)
  fill do
    move_to(0, 0)
    curve_to([0.057, -0.197], bounds: [[0, -0.134], [0.023, -0.19]])
    curve_to([0.41, 0.301], bounds: [[0.16, -0.217], [0.37, 0.204]])
    curve_to([2.275, 3.028], bounds: [[0.837, 1.357], [1.489, 2.249]])
    curve_to([9.806, 7.551], bounds: [[4.335, 5.073], [7.338, 6.32]])
    curve_to([16.896, 14.738], bounds: [[12.527, 8.908], [16.896, 11.177]])
    curve_to([15.726, 18.903], bounds: [[16.896, 16.237], [16.642, 17.68]])
    curve_to([13.256, 14.939], bounds: [[15.726, 17.187], [14.416, 16.018]])
    curve_to([10.052, 12.794], bounds: [[12.319, 14.067], [11.161, 13.417]])
    curve_to([6.074, 10.713], bounds: [[8.747, 12.062], [7.409, 11.388]])
    curve_to([2.398, 8.569], bounds: [[4.808, 10.074], [3.508, 9.465]])
    curve_to([0.153, 5.796], bounds: [[1.487, 7.833], [0.602, 6.897]])
    curve_to([0, 4.279], bounds: [[-0.049, 5.301], [0, 4.803]])
    line_to(0, 0)
  end
  restore_graphics_state
end
