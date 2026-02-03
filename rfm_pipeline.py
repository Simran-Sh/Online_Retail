def extract():
    # read CSV / pull from SQL
    pass

def transform():
    # cleaning, RFM, cohort, MBA
    pass

def load():
    # write to SQL tables
    pass

def main():
    extract()
    transform()
    load()

if __name__ == "__main__":
    main()

import logging

logging.basicConfig(
    filename="rfm_pipeline.log",
    level=logging.INFO
)

try:
    main()
    logging.info("Pipeline ran successfully")
except Exception as e:
    logging.error("Pipeline failed", exc_info=True)
