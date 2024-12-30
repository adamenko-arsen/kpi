if __name__ == '__main__':
    print(f'File {__file__} can be used only as a library')
    exit(1)

import matplotlib.pyplot as plt

from typing import List, Dict

# TODO
class Drawer:
    def __init__(self):
        self.comparisons = []
 
    def AddNewComparison(self, variant: str, comparison: Dict[str, List[int]], colors: List[str]):
        self.comparisons += [{
            'colors':  colors,
            'variant': variant,
            'results': comparison
        }]

    def Draw(self):
        comparisons = self.comparisons

        fig, axs = plt.subplots(len(comparisons), 2, figsize=(10, 8))

        for comp_idx, comp in enumerate(comparisons):
            ax = axs[comp_idx, 0]

            for res_idx, res in enumerate(comp['results']):
                best_values = comp['results'][res]
                ax.plot(
                    range(1, len(best_values) + 1),
                    best_values,
                    color = comp['colors'][res_idx]
                )

            ax.title(f'Comparison of variations of <{comp["variant"]}>')
            ax.set_xlabel('Iterations count')
            ax.set_ylabel('Current best value')

            ax.grid(which = 'major', color = '#777')
            ax.minorticks_on()
            ax.grid(which = 'minor', color = '#aaa')

            ax.legend()

        plt.show()
