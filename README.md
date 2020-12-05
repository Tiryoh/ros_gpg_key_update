# ros_gpg_key_update

A simple script to update gpg keys for packages.ros.org

details: https://discourse.ros.org/t/new-gpg-keys-deployed-for-packages-ros-org/9454

## Usage

Just run the following command on your ROS installed environment.

```sh
curl -SsfL git.io/ros-gpg-key-update | sh
```

If you want to download the script before execution, run the following command.

```sh
curl -Ssf -o ros-gpg-key-update.sh https://raw.githubusercontent.com/Tiryoh/ros_gpg_key_update/6b19c5d5f6526321329cbf05f76791a484e8cc1a/run.sh
bash ./ros-gpg-key-update.sh
```

## License

[CC0 1.0](https://creativecommons.org/publicdomain/zero/1.0/deed)
