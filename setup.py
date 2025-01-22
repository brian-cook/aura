from setuptools import setup, find_packages

setup(
    name="aura",
    version="0.1",
    description="World of Warcraft automation and WeakAuras management tool",
    author="Mike",
    packages=find_packages(),
    install_requires=[
        "pytest==7.3.1",
        "lupa==1.14.1",
        "pyautogui",
        "pynput",
    ],
    python_requires=">=3.7",
) 