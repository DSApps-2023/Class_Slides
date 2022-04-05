import numpy as np
import pandas as pd
import timeit

n_list = [1000, 10000, 100000, 1000000]
masking_times = []
nplist_times = []
listcomp_times = []
for n in n_list:
  a = np.random.uniform(size=n)
  masking_time = timeit.timeit('a[a < 0.1]', 'from __main__ import a', number=100)
  nplist_time = timeit.timeit('[i for i in a if i < 0.1]', 'from __main__ import a', number=100)
  l = list(a)
  listcomp_time = timeit.timeit('[i for i in l if i < 0.1]', 'from __main__ import l', number=100)
  masking_times.append(masking_time)
  nplist_times.append(nplist_time)
  listcomp_times.append(listcomp_time)

pd.DataFrame({'n': n_list, 'masking_time': masking_times, 'listcomp_time': listcomp_times, 'nplist_time': nplist_times})