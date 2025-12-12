all:
	docker build -t repro-28 .
	docker run -v ../../data/CrowdstormingDataJuly1st.csv:/analysis/data.csv repro-28