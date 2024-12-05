from constants import *

class BatteryData: 
    """Class to store battery data"""

    def __init__(self, timestamp, current, charge):
        self.timestamp = timestamp
        self.current = current
        self.charge = charge 