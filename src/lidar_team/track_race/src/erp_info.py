class erp42:
    def __init__(self):
        # Parameters
        self.k = 0.1  # look forward gain
        self.Lfc = 2.5
        self.Kp = 1.0  # speed proportional gain
        self.dt = 0.1  # [s] time tick
        self.WB = 1.04  # [m] wheel base of vehicle
        self.x = -1.1


class erp42morai:
    def __init__(self):
        # Parameters
        self.k = 0.1  # look forward gain
        self.Lfc = 3.0
        self.Kp = 1.0  # speed proportional gain
        self.dt = 0.1  # [s] time tick
        self.WB = 0.78  # [m] wheel base of vehicle
        self.x = -0.96


if __name__ == '__main__':
    pass
