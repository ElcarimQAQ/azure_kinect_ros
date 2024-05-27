# Kinect Azure Camera

https://learn.microsoft.com/zh-CN/azure/Kinect-dk/sensor-sdk-download

**[Azure-Kinect-Sensor SDK](https://github.com/microsoft/Azure-Kinect-Sensor-SDK)**

# Download SDK

配置 [Microsoft 的包存储库](https://packages.microsoft.com/):

- Ubuntu 18.04 (Bionic)

  ```bash
  curl -sSL https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
  
  sudo apt-add-repository https://packages.microsoft.com/ubuntu/18.04/prod
  
  sudo apt-get update
  ```


- Ubuntu 20.04 (Focal)

  ```bash
  curl -sSL https://packages.microsoft.com/keys/microsoft.asc | sudo tee /etc/apt/trusted.gpg.d/microsoft.asc`
  
  sudo apt-add-repository https://packages.microsoft.com/ubuntu/20.04/prod
  
  sudo apt-get update
  ```



安装所需的包。 `k4a-tools` 包中包含 [Azure Kinect 查看器](https://learn.microsoft.com/zh-CN/azure/Kinect-dk/azure-kinect-viewer)、[Azure Kinect 录制器](https://learn.microsoft.com/zh-CN/azure/Kinect-dk/record-sensor-streams-file)和 [Azure Kinect 固件工具](https://learn.microsoft.com/zh-CN/azure/Kinect-dk/azure-kinect-firmware-tool)。

仅支持在Ubuntu18.04下：

```bash
sudo apt install k4a-tools
```

libk4a<major>.<minor>-dev包。<major>和<minor>是其版本号。

github 最新为1.4.1

github:https://github.com/microsoft/Azure-Kinect-Sensor-SDK/releases

```bash
sudo apt install libk4a1.4-dev
```



Linux Device Setup

On Linux, once attached, the device should automatically enumerate and load all drivers. However, in order to use the Azure Kinect SDK with the device and without being 'root', you will need to setup udev rules. We have these rules checked into this repo under 'scripts/99-k4a.rules'. To do so:

- Copy 'scripts/99-k4a.rules' into '/etc/udev/rules.d/'.

  ```bash
  # Bus 002 Device 116: ID 045e:097a Microsoft Corp.  - Generic Superspeed USB Hub
  # Bus 001 Device 015: ID 045e:097b Microsoft Corp.  - Generic USB Hub
  # Bus 002 Device 118: ID 045e:097c Microsoft Corp.  - Azure Kinect Depth Camera
  # Bus 002 Device 117: ID 045e:097d Microsoft Corp.  - Azure Kinect 4K Camera
  # Bus 001 Device 016: ID 045e:097e Microsoft Corp.  - Azure Kinect Microphone Array
  
  BUS!="usb", ACTION!="add", SUBSYSTEM!=="usb_device", GOTO="k4a_logic_rules_end"
  
  ATTRS{idVendor}=="045e", ATTRS{idProduct}=="097a", MODE="0666", GROUP="plugdev"
  ATTRS{idVendor}=="045e", ATTRS{idProduct}=="097b", MODE="0666", GROUP="plugdev"
  ATTRS{idVendor}=="045e", ATTRS{idProduct}=="097c", MODE="0666", GROUP="plugdev"
  ATTRS{idVendor}=="045e", ATTRS{idProduct}=="097d", MODE="0666", GROUP="plugdev"
  ATTRS{idVendor}=="045e", ATTRS{idProduct}=="097e", MODE="0666", GROUP="plugdev"
  
  LABEL="k4a_logic_rules_end"
  ```

- Detach and reattach Azure Kinect devices if attached during this process.

Once complete, the Azure Kinect camera is available without being 'root'.

启动：k4aviewer

# Building the Azure Kinect ROS Driver

https://github.com/microsoft/Azure_Kinect_ROS_Driver/blob/melodic/docs/building.md

# Python

PyKinect:https://github.com/columbia-ai-robotics/PyKinect

pyk4a:https://github.com/etiennedub/pyk4a

Azure-Kinect-Python:https://github.com/hexops/Azure-Kinect-Python

![image-20221205174411243](http://picbed.elcarimqaq.top/img/image-20221205174411243.png)

Camera tcp转发:

```bash
python run_server.py --port 1111

./frpc -c ./frpc.ini
```

# 基于Docker 使用SDK

由于官方提供的只有Ubuntu 18.04的SDK，对于其他的Ubunut版本可以使用Docker。

使用微软在docker hub上提供的镜像[^1]。

```bash
docker pull mcr.microsoft.com/akbuilder-linux:v3
```

或在azure_kinect_ros[^2]基础上创建Docker环境。

这个环境的详细包括：

- microsoft/Azure Kinect Sensor SDK Version : 1.4
- microsoft/Azure Kinect Body Tracking SDK Version : 1.1
- microsoft/Azure_Kinect_ROS_Driver: Enable (Build ◎)
  - Body Track : Enable (Build ◎)
- Nvidia Driver : 440
- Nvidia Docker2
- Docker Base Image : nvidia/cuda:10.1-cudnn7-devel-ubuntu18.04
- ROS Distribution : melodic



v1添加：

- k4aviewer
- 基于Open3d 的Pykinect



# camera matrix

![image-20221210213821970](http://picbed.elcarimqaq.top/img/image-20221210213821970.png)

## 定义假的相机参数
```python
import numpy as np

# 定义假的相机 pose 矩阵
fake_pose = np.array([[1, 0, 0, 0],
                      [0, 1, 0, 0],
                      [0, 0, 1, 0],
                      [0, 0, 0, 1]])
np.savetxt('top_down_m1_cam_pose.txt', fake_pose)
```

在这段代码中，我们使用 numpy 的 array() 函数来定义假的相机 pose 矩阵。这个假的相机 pose 矩阵表示相机在三维空间中的位置和方向。

fake_pose 数组的每一行表示相机的一个属性，例如位置、方向等。第一行 [1, 0, 0, 0] 表示相机在 x 方向上的位移，第二行 [0, 1, 0, 0] 表示相机在 y 方向上的位移，第三行 [0, 0, 1, 0] 表示相机在 z 方向上的位移，第四行 [0, 0, 0, 1] 表示相机的旋转矩阵。



假的相机 camera_depth_offset ：

```python
import numpy as np

# 定义假的相机 camera_depth_offset
fake_offset = np.array([1.0, 0.0, 0.0])

```

这个假的相机 camera_depth_offset 表示相机与物体之间的距离，其中 1.0、0.0、0.0 分别表示相机与物体之间在 x、y、z 方向上的距离。

# 参考资料

[^1]: https://hub.docker.com/_/microsoft-akbuilder-linux?tab=description
[^2]: https://github.com/chakio/azure_kinect_ros

