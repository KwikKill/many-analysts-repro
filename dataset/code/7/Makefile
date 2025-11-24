all:
	docker build -t repro-7 .
	docker run -v ../../data/CrowdstormingDataJuly1st.csv:/analysis/CrowdstormingDataset.csv -v ./output:/analysis/output repro-7