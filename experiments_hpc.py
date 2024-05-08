import sys
import os
import itertools
import git
import time


def set_sweep_config():

    hyperparameter_experiments = []

    nfs = ['2 4', '2 16', '4 4', '4 16']
    lrs = [0.001]
    seeds = list(range(1, 21))

    ####################################################################################################################
    hyperparameter_config = {
        'dataset': ['tanh_zeromean'],
        'H': [1],
        'prior_param': ['0 1'],
        'base_dist': ['gengamma', 'gaussian'],
        'grad_flag': [False],
        'lr':  lrs,
        'nf': nfs,
        'seed': seeds
    }
    keys, values = zip(*hyperparameter_config.items())
    hyperparameter_experiments += [dict(zip(keys, v)) for v in itertools.product(*values)]

    return hyperparameter_experiments


def main(taskid):

    hyperparameter_experiments = set_sweep_config()
    
    timestr = time.strftime("%m%d")
    repo = git.Repo(search_parent_directories=True)
    sha = repo.head.object.hexsha
    sha = sha[0:7]
    print(repo)
    exit()
    path = '{}_results{}/taskid{}/'.format(timestr, sha, taskid)

    taskid = int(taskid[0])
    temp = hyperparameter_experiments[taskid]


    os.system("python3 main.py " 
              "--data %s %s "
              "--ns 1000 1196 1431 1711 2047 2448 2929 3503 4190 5012 6579 8111 10000" # np.rint(np.logspace(3.0, 3.7, 10)).astype(int)
              "--var_mode %s %s %s "
              "--lr %s "
              "--epochs 5000 "
              "--display_interval 5000 "
              "--seed %s "
              "--path %s "
              % (temp['dataset'], temp['H'],
                 temp['base_dist'], temp['nf'], temp['grad_flag'], temp['lr'],
                 temp['seed'],
                 path)
              )


if __name__ == "__main__":
    main(sys.argv[1:])