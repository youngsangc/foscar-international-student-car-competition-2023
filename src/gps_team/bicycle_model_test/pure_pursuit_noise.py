import matplotlib.pyplot as plt
import numpy as np
import sys

# 임의의 경로를 생성하는 함수
def create_path(example):
    if example == 'path_example1':
        # 원형 경로
        theta = np.linspace(0, 2 * np.pi, 1000)
        x = 100 * np.cos(theta)
        y = 100 * np.sin(theta)
    elif example == 'path_example2':
        # S자형 경로
        x = np.linspace(-100, 100, 1000)
        y = np.sin(x)*0.5
    elif example == 'path_example3':
        # 직선 경로
        x = np.linspace(-100, 100, 1000)
        y = np.zeros_like(x)
    else:
        raise ValueError("Invalid path example")
    return x, y

# 차량 클래스
class Vehicle:
    def __init__(self, length=1.0, velocity=2.0, dt=0.1, noise=False):
        self.length = length
        self.velocity = velocity
        self.dt = dt
        self.noise = noise
        self.x = 0.0
        self.y = 0.0
        self.theta = 0.0
        self.k = 0.1  # Lookahead distance factor
        self.Lfc = 1  # Lookahead distance

    def pure_pursuit_control(self, path, target_idx):
        # 목표 지점 설정
        goal_x, goal_y = path[target_idx]
        # 차량과 목표 지점과의 각도를 계산
        alpha = np.arctan2(goal_y - self.y, goal_x - self.x) - self.theta
        Lf = self.k * self.velocity + self.Lfc

        # 다이나믹 전방주시거리
        delta = np.arctan2(2.0 * self.length * np.sin(alpha) / Lf, 1.0)
        return delta

    def update(self, delta):
        # 차량 상태 업데이트
        if self.noise:
            noise_velocity = self.velocity + np.random.randn() * 1
            noise_steering_angle = np.tan(delta) + np.random.randn() * 1.2
            
            self.x += noise_velocity * np.cos(self.theta) * self.dt
            self.y += noise_velocity * np.sin(self.theta) * self.dt
            self.theta += noise_velocity / self.length * noise_steering_angle * self.dt
        else:
            self.x += self.velocity * np.cos(self.theta) * self.dt
            self.y += self.velocity * np.sin(self.theta) * self.dt
            self.theta += self.velocity / self.length * np.tan(delta) * self.dt


    def find_target_index(self, path):
        # lookahead distance 안에서 가장 가까운 경로 포인트 찾기
        distances = np.sqrt((path[:, 0] - self.x) ** 2 + (path[:, 1] - self.y) ** 2)
        target_idx = np.argmin(np.abs(distances - self.Lfc))
        return target_idx

# 메인 함수
def main(path_name):
    # 경로 생성
    x, y = create_path(path_name)
    path = np.vstack((x, y)).T

    # 차량 두 대 생성 (하나는 노이즈 없이, 하나는 노이즈 있게)
    car_ideal = Vehicle(noise=False)
    car_noisy = Vehicle(noise=True)

    

    # 시뮬레이션 시작
    plt.figure()
    plt.plot(x, y, 'r.')  # 경로를 빨간색 점으로 표시
    ideal_path_x, ideal_path_y = [car_ideal.x], [car_ideal.y]
    noisy_path_x, noisy_path_y = [car_noisy.x], [car_noisy.y]

    target_idx = car_ideal.find_target_index(path)

    while target_idx < len(path):
        # 이상적인 조건에서 차량 업데이트
        delta_ideal = car_ideal.pure_pursuit_control(path, target_idx)
        car_ideal.update(delta_ideal)

        # 노이즈가 포함된 조건에서 차량 업데이트
        delta_noisy = car_noisy.pure_pursuit_control(path, target_idx)
        car_noisy.update(delta_noisy)

        # 차량 경로에 추가
        ideal_path_x.append(car_ideal.x)
        ideal_path_y.append(car_ideal.y)
        noisy_path_x.append(car_noisy.x)
        noisy_path_y.append(car_noisy.y)

        print(f"car_ideal.theta : {car_ideal.theta}, car_noisy.theta : {car_noisy.theta}")
        print(f"Heading Error : {abs(car_ideal.theta-car_noisy.theta)}")


        plt.cla()
        plt.plot(x, y, 'r.', label='Desired Path')  # 원하는 경로
        plt.plot(ideal_path_x, ideal_path_y, 'b.', label='Ideal Path')  # 이상적인 차량 경로
        plt.plot(noisy_path_x, noisy_path_y, 'g.', label='Noisy Path')  # 노이즈가 섞인 차량 경로
        plt.scatter(car_ideal.x, car_ideal.y, color='blue', label='Ideal Vehicle')
        plt.scatter(car_noisy.x, car_noisy.y, color='green', label='Noisy Vehicle')
        plt.xlim(-100, 100)
        plt.ylim(-100, 100)
        plt.legend()
        plt.pause(0.01)

        target_idx += 1

    plt.show()

# 프로그램 시작점
if __name__ == '__main__':
    if len(sys.argv) > 1:
        path_name = sys.argv[1]
    else:
        path_name = 'path_example1'
    main(path_name)
