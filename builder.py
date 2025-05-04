import shlex
import os
from loguru import logger
from setuptools.command.build_ext import build_ext


class ZigBuilder(build_ext):
    def build_extension(self, ext):
        assert len(ext.sources) == 1
        logger.add("test.log")

        if not os.path.exists(self.build_lib):
            os.makedirs(self.build_lib)
        mode = "Debug" if self.debug else "ReleaseFast"
        shell = [
            "zig",
            "build-lib",
            "-O",
            mode,
            "-lc",
            f"-femit-bin={self.get_ext_fullpath(ext.name)}",
            "-fallow-shlib-undefined",
            "-dynamic",
            *[f"-I{d}" for d in self.include_dirs],
            ext.sources[0],
            "--verbose-link",
            "--verbose-cc",
        ]
        logger.info(shell)
        logger.info(shlex.join(shell))
        self.spawn(shell)
