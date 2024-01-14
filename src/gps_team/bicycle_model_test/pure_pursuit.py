import matplotlib.pyplot as plt
import numpy as np
import sys
import time

# 임의의 경로를 생성하는 함수
def create_path(example):
    if example == 'path_example1':
        # 원형 경로
        theta = np.linspace(0, 2 * np.pi, 100)
        x = 10 * np.cos(theta)
        y = 10 * np.sin(theta)
    elif example == 'path_example2':
        # S자형 경로
        x = np.linspace(-10, 10, 100)
        y = np.sin(2*x)
    elif example == 'path_example3':
        # 직선 경로
        x = np.linspace(-10, 10, 100)
        y = np.zeros_like(x)
    else:
        raise ValueError("Invalid path example")

    return x, y

# 차량 클래스
class Vehicle:
    def __init__(self, length=1.0, velocity=2.0, dt=0.1):
        self.length = length
        self.velocity = velocity
        self.dt = dt
        self.x = 0.0
        self.y = 0.0
        self.theta = 0.0
        self.k = 0.1  # Lookahead distance factor
        self.Lfc = 1.0  # Lookahead distance

    def pure_pursuit_control(self, path, target_idx):
        # 목표 지점 설정
        goal_x, goal_y = path[target_idx]

        # 차량과 목표 지점과의 각도를 계산
        alpha = np.arctan2(goal_y - self.y, goal_x - self.x) - self.theta
        Lf = self.k * self.velocity + self.Lfc

        # 앞바퀴까지의 거리 Lf에 따라 차량이 도달해야 할 방향으로 회전하는 각도를 계산
        delta = np.arctan2(2.0 * self.length * np.sin(alpha) / Lf, 1.0)
        return delta

    def update(self, delta):
        # 차량 상태 업데이트
        self.x += self.velocity * np.cos(self.theta) * self.dt
        self.y += self.velocity * np.sin(self.theta) * self.dt
        self.theta += self.velocity / self.length * np.tan(delta) * self.dt

    def find_target_index(self, path):
        # lookahead distance 안에서 가장 가까운 경로 포인트 찾기
        distances = np.sqrt((path[:, 0] - self.x) ** 2 + (path[:, 1] - self.y) ** 2)
        target_idx = np.argmin(np.abs(distances - self.Lfc))
        return target_idx

def main(path_name):
    # 경로 생성
    x, y = create_path(path_name)
    path = np.vstack((x, y)).T

    # 차량 생성
    car = Vehicle()

    # 시뮬레이션 시작
    plt.figure()
    plt.plot(x, y, 'r.')  # 경로를 빨간색 점으로 표시
    car_x, car_y = [car.x], [car.y]

    target_idx = car.find_target_index(path)

    while True:
        delta = car.pure_pursuit_control(path, target_idx)
        car.update(delta)

        car_x.append(car.x)
        car_y.append(car.y)

        plt.cla()
        plt.plot(x, y, 'r.')  # 경로를 빨간색 점으로 표시
        plt.plot(car_x, car_y, 'b.')  # 차량의 경로를 파란색 점으로 표시
        plt.plot(car.x, car.y, 'bo')  # 현재 차량의 위치
        plt.xlim(-15, 15)
        plt.ylim(-15, 15)
        plt.pause(0.01)

        target_idx += 1
        if target_idx >= len(path):
            break

    plt.show()

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python3 pure_pursuit.py path_example1")
        sys.exit(1)

    path_name = sys.argv[1]
    main(path_name)
