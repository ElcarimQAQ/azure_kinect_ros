xhost +
nvidia-docker &> /dev/null
if [ $? -ne 0 ]; then
    echo "=============================" 
    echo "=nvidia docker not installed="
    echo "============================="
    docker run -it \
    --privileged \
    --env=DISPLAY=$DISPLAY \
    --env=DISPLAY=$DISPLAY \
    --env="XAUTHORITY=${XAUTH}" \
    --env="QT_X11_NO_MITSHM=1" \
    --env="LIBGL_ALWAYS_INDIRECT=" \
    --env="LIBGL_ALWAYS_SOFTWARE=1" \
    --rm \
    -v /etc/group:/etc/group:ro \
    -v /etc/passwd:/etc/passwd:ro \
    -v "/$(pwd)/user_launch/:/catkin_ws/src/Azure_Kinect_ROS_Driver/launch/user_launch" \
    -v "/$(pwd)/scripts/:/catkin_ws/src/Azure_Kinect_ROS_Driver/scripts/scripts" \
    -v "/$(pwd)/rviz/:/catkin_ws/src/Azure_Kinect_ROS_Driver/rviz" \
    -v "/$(pwd)/pose_data/:/pose_data" \
    --net host \
    elcarimqaq/kinect_ros:latest
else
   echo "=========================" 
   echo "=nvidia docker installed="
   echo "========================="
   docker run -it \
   --privileged \
    --runtime=nvidia \
    --env=DISPLAY=$DISPLAY \
    --env="XAUTHORITY=${XAUTH}" \
    --env="QT_X11_NO_MITSHM=1" \
    --env="LIBGL_ALWAYS_INDIRECT=" \
    --env="LIBGL_ALWAYS_SOFTWARE=1" \
    --rm \
    -v /etc/group:/etc/group:ro \
    -v /etc/passwd:/etc/passwd:ro \
    -v "/$(pwd)/user_launch/:/catkin_ws/src/Azure_Kinect_ROS_Driver/launch/user_launch" \
    -v "/$(pwd)/scripts/:/catkin_ws/src/Azure_Kinect_ROS_Driver/scripts/scripts" \
    -v "/$(pwd)/rviz/:/catkin_ws/src/Azure_Kinect_ROS_Driver/rviz" \
    -v "/$(pwd)/pose_data/:/pose_data" \
    -v /home/lbyang/workspace/flingbot/real_world/PyKinect:/PyKinect \
    --net host \
    elcarimqaq/kinect_ros:v1
fi
