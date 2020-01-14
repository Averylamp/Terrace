"""
Class related to specific effects.
"""
import matplotlib.pyplot as plt
import numpy as np
import matplotlib.animation as animation

from pointcloud import PointClouder


class Effects(object):
    """
    Class for handling effects.
    """

    def __init__(self, bgr, depth, show_gui=False, output_filename="effects.mp4"):
        """
        Args:
        bgr
        depth
        show_gui
        output_filename
        """
        # pointcloud class
        self.pointclouder = PointClouder(bgr, depth)
        # effect image sequence
        self.images_sequence = []
        # store the animation
        self.ani = None
        # params
        self.show_gui = show_gui
        self.output_filename = output_filename

    def generate_image_sequence(self):
        """
        Write a sequences of images to product the effect.
        """
        raise NotImplementedError

    def produce_animation(self):
        print("Producing animation")
        fig = plt.figure()
        ims = []
        for image in self.images_sequence:
            # need to reverse bgr to rgb
            im = plt.imshow(image[:, :, ::-1], animated=True)
            ims.append([im])

        self.ani = animation.ArtistAnimation(fig, ims, interval=50, blit=True,
                                             repeat_delay=1000)
        if self.output_filename:
            print("Saving animation to {}".format(self.output_filename))
            self.ani.save(self.output_filename)
        if self.show_gui:
            print("Showing gui")
            plt.show()

    def run_effect(self):
        """
        Run the entire effect.
        """
        print("Running effect")
        self.generate_image_sequence()
        if self.images_sequence == []:
            raise ValueError(
                "generate_image_sequence() must generate an image sequence.")
        self.produce_animation()


class TDKenBurns(Effects):
    """
    3D Ken burns effect.
    """

    def __init__(self, bgr, depth, show_gui=False):
        super().__init__(bgr, depth, show_gui=show_gui)

    def generate_image_sequence(self):
        path = list(np.linspace(0.0, 0.1, 10)) + \
            list(np.linspace(0.1, -0.1, 5)) + list(np.linspace(-0.1, -0.0, 5))
        # move camera in x direction
        for x in path:
            extrinsics = np.identity(4, dtype="float64")
            extrinsics[0][3] = x
            image = self.pointclouder.get_image_from_pointcloud(
                extrinsics=extrinsics
            )
            self.images_sequence.append(image)
        # move camera in y direction
        for y in path:
            extrinsics = np.identity(4, dtype="float64")
            extrinsics[1][3] = y
            image = self.pointclouder.get_image_from_pointcloud(
                extrinsics=extrinsics
            )
            self.images_sequence.append(image)

        # print(type(x_path))
        # raise ValueError("stop")
        # for x in np.linspace(0.0, 0.1, 10):
        #     extrinsics = np.identity(4, dtype="float64")
        #     extrinsics[0][3] = x
        #     image = pointclouder.get_image_from_pointcloud(
        #         extrinsics=extrinsics
        #     )
        #     im = plt.imshow(image[:,:,::-1], animated=True)
        #     ims.append([im])
        # for x in np.linspace(0.1, -0.1, 10):
        #     extrinsics = np.identity(4, dtype="float64")
        #     extrinsics[0][3] = x
        #     image = pointclouder.get_image_from_pointcloud(
        #         extrinsics=extrinsics
        #     )
        #     im = plt.imshow(image[:,:,::-1], animated=True)
        #     ims.append([im])
        # for x in np.linspace(-0.1, 0.0, 5):
        #     extrinsics = np.identity(4, dtype="float64")
        #     extrinsics[0][3] = x
        #     image = pointclouder.get_image_from_pointcloud(
        #         extrinsics=extrinsics
        #     )
        #     im = plt.imshow(image[:,:,::-1], animated=True)
        #     ims.append([im])

        # for x in np.linspace(0.0, 0.1, 10):
        #     extrinsics = np.identity(4, dtype="float64")
        #     extrinsics[1][3] = x
        #     image = pointclouder.get_image_from_pointcloud(
        #         extrinsics=extrinsics
        #     )
        #     im = plt.imshow(image[:,:,::-1], animated=True)
        #     ims.append([im])
        # for x in np.linspace(0.1, -0.1, 10):
        #     extrinsics = np.identity(4, dtype="float64")
        #     extrinsics[1][3] = x
        #     image = pointclouder.get_image_from_pointcloud(
        #         extrinsics=extrinsics
        #     )
        #     im = plt.imshow(image[:,:,::-1], animated=True)
        #     ims.append([im])
        # for x in np.linspace(-0.1, 0.0, 5):
        #     extrinsics = np.identity(4, dtype="float64")
        #     extrinsics[1][3] = x
        #     image = pointclouder.get_image_from_pointcloud(
        #         extrinsics=extrinsics
        #     )
        #     im = plt.imshow(image[:,:,::-1], animated=True)
        #     ims.append([im])
