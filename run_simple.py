from loguru import logger
import sys

def handler(frame, event, arg):
    logger.info(frame)
    logger.info(event)
    logger.info(arg)

sys.settrace(handler)

def main():
    import simple
    logger.info(simple.mapAList([1,2,3]))


if __name__ == "__main__":
    main()
