import logging as log
import os

class Logger(log.Logger):

    def __init__(self):
        super().__init__('global_logger')
        os.makedirs('./logs', exist_ok=True)
        log_file_path = os.path.join('./logs', "supply_sync.log")
        log.basicConfig(filename=log_file_path, level=log.INFO,
                        format="%(asctime)s - %(levelname)s - %(message)s")
        self.logger_obj = log.getLogger(__name__)

