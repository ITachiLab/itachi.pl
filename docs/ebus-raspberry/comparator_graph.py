import matplotlib as mpl
import matplotlib.pyplot as plt
import numpy as np


def make_divider(r1, r2):
    def divider(vin):
        return (r2 / (r1 + r2)) * vin

    return divider


def make_comparator(vref, vdd, vss):
    def comparator(vin):
        return vss if vin <= vref else vdd

    return comparator


def main():
    div = make_divider(237, 100)
    cmp = make_comparator(3.5, 7, 0)

    vin = np.arange(9, 24.5, 0.01)
    div_out = [div(v) for v in vin]
    cmp_out = [cmp(v) for v in div_out]

    fig, ax = plt.subplots()
    ax2 = ax.twinx()

    ax.plot(vin, div_out, color="blue")
    ax.set_xlabel("eBUS [V]")
    ax.set_ylabel("Divider output [V]", color="blue")
    ax.annotate("11.795 V", xy=(11.795, 3.5), \
            xytext=(14, 3.2), \
            arrowprops=dict(arrowstyle="->"))

    ax2.step(vin, cmp_out, color="red")
    ax2.set_ylabel("Comparator output [V]", color="red")

    ax.grid(True)

    plt.plot()
    plt.savefig("outputs.png", bbox_inches="tight")

if __name__ == "__main__":
    main()
