<template>
	<div class="task-form">
		<h2>{{ isEditing ? "Edit Task" : "Create New Task" }}</h2>
		<form @submit.prevent="handleSubmit">
			<div class="form-group">
				<label for="title">Title</label>
				<input
					type="text"
					id="title"
					v-model="form.title"
					required
					class="form-control"
				/>
			</div>
			<div class="form-group">
				<label for="description">Description</label>
				<textarea
					id="description"
					v-model="form.description"
					class="form-control"
					rows="3"
				></textarea>
			</div>
			<div class="form-group">
				<label class="checkbox-label">
					<input type="checkbox" v-model="form.completed" />
					Completed
				</label>
			</div>
			<div class="form-actions">
				<button type="submit" class="btn btn-primary">
					{{ isEditing ? "Update" : "Create" }}
				</button>
				<button type="button" @click="cancel" class="btn btn-secondary">
					Cancel
				</button>
			</div>
		</form>
	</div>
</template>

<script>
import axios from "axios";

export default {
	name: "TaskForm",
	props: {
		task: {
			type: Object,
			default: null,
		},
	},
	data() {
		return {
			form: {
				title: "",
				description: "",
				completed: false,
			},
		};
	},
	computed: {
		isEditing() {
			return this.task !== null;
		},
	},
	watch: {
		task: {
			immediate: true,
			handler(newTask) {
				if (newTask) {
					this.form = { ...newTask };
				} else {
					this.form = {
						title: "",
						description: "",
						completed: false,
					};
				}
			},
		},
	},
	methods: {
		async handleSubmit() {
			try {
				if (this.isEditing) {
					await axios.put(`/api/task/${this.task.id}`, this.form);
				} else {
					await axios.post("/api/task", this.form);
				}
				this.$emit("task-saved");
				this.cancel();
			} catch (error) {
				console.error("Error saving task:", error);
			}
		},
		cancel() {
			this.$emit("cancel");
		},
	},
};
</script>

<style scoped>
.task-form {
	max-width: 600px;
	margin: 0 auto;
	padding: 20px;
}

.form-group {
	margin-bottom: 15px;
}

.form-control {
	width: 100%;
	padding: 8px;
	border: 1px solid #ddd;
	border-radius: 4px;
}

.checkbox-label {
	display: flex;
	align-items: center;
	gap: 8px;
}

.form-actions {
	display: flex;
	gap: 10px;
	margin-top: 20px;
}

.btn {
	padding: 8px 16px;
	border: none;
	border-radius: 4px;
	cursor: pointer;
}

.btn-primary {
	background-color: #007bff;
	color: white;
}

.btn-secondary {
	background-color: #6c757d;
	color: white;
}
</style>
