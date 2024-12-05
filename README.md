# Battery characterization

Those scripts are used to characterize the battery of a laptop. The scripts are written in Python and Bash and are used to log battery data to CSV files for further analysis. The scripts are designed to be run on Linux systems.

## Prerequisites
- Linux system with `/sys/class/power_supply/` for battery information.
- `acpi` command installed (for temperature reading, optional).
- Bash shell.
- Python 3.12 or higher.

---

## Setup

```bash
source ./setup.sh
```

## Usage

- To log **first battery** data every **30 seconds** to a file named `battery_0_log.csv` indefinitely:

    ```bash
    ./battery_logger.sh -o battery_0_log.csv -i 30
    ```
Further information can be found in the [README.md](./script/README.md) file in scripts.

- To clean files produced by analysis:

    ```bash
    clean_analysis
    ```
- To remove all data logged by the battery logger:

    ```bash
    purge_data
    ```
