<template>
	<div class="task-list">
		<h2>Tasks</h2>
		<div v-if="loading" class="loading">Loading...</div>
		<div v-else-if="error" class="error">{{ error }}</div>
		<div v-else>
			<div v-for="task in tasks" :key="task.id" class="task-item">
				<div class="task-content">
					<h3>{{ task.title }}</h3>
					<p>{{ task.description }}</p>
					<div class="task-status">
						<span>Status: {{ task.completed ? "Completed" : "Pending" }}</span>
						<button @click="toggleTask(task)" class="btn btn-sm">
							{{ task.completed ? "Mark as Pending" : "Mark as Completed" }}
						</button>
					</div>
				</div>
				<div class="task-actions">
					<button @click="editTask(task)" class="btn btn-sm btn-primary">
						Edit
					</button>
					<button @click="deleteTask(task.id)" class="btn btn-sm btn-danger">
						Delete
					</button>
				</div>
			</div>
		</div>
	</div>
</template>

<script>
import axios from "axios";

export default {
	name: "TaskList",
	data() {
		return {
			tasks: [],
			loading: true,
			error: null,
		};
	},
	async created() {
		await this.fetchTasks();
	},
	methods: {
		async fetchTasks() {
			try {
				const response = await axios.get("/api/task");
				this.tasks = response.data;
				this.loading = false;
			} catch (error) {
				this.error = "Error fetching tasks";
				this.loading = false;
			}
		},
		async toggleTask(task) {
			try {
				await axios.put(`/api/task/${task.id}`, {
					...task,
					completed: !task.completed,
				});
				await this.fetchTasks();
			} catch (error) {
				this.error = "Error updating task";
			}
		},
		editTask(task) {
			this.$emit("edit-task", task);
		},
		async deleteTask(id) {
			if (confirm("Are you sure you want to delete this task?")) {
				try {
					await axios.delete(`/api/task/${id}`);
					await this.fetchTasks();
				} catch (error) {
					this.error = "Error deleting task";
				}
			}
		},
	},
};
</script>

<style scoped>
.task-list {
	max-width: 800px;
	margin: 0 auto;
	padding: 20px;
}

.task-item {
	border: 1px solid #ddd;
	border-radius: 4px;
	padding: 15px;
	margin-bottom: 10px;
	display: flex;
	justify-content: space-between;
	align-items: center;
}

.task-content {
	flex: 1;
}

.task-status {
	margin-top: 10px;
	display: flex;
	align-items: center;
	gap: 10px;
}

.task-actions {
	display: flex;
	gap: 10px;
}

.btn {
	padding: 5px 10px;
	border: none;
	border-radius: 4px;
	cursor: pointer;
}

.btn-sm {
	font-size: 0.875rem;
}

.btn-primary {
	background-color: #007bff;
	color: white;
}

.btn-danger {
	background-color: #dc3545;
	color: white;
}

.loading,
.error {
	text-align: center;
	padding: 20px;
}
</style>
