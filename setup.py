from setuptools import setup, Extension
from builder import ZigBuilder

simple = Extension("simple", sources=["src/mymodule.zig"])

setup(
    name="simple",
    version="0.0.1",
    description="a experiment create Python module in Zig",
    ext_modules=[simple],
    cmdclass={"build_ext": ZigBuilder},
)
